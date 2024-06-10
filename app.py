import os
import logging

# 설정된 환경 변수를 확인
gradio_frpc_path = os.getenv("GRADIO_FRPC_PATH")
if gradio_frpc_path:
    logging.info(f"GRADIO_FRPC_PATH is set to: {gradio_frpc_path}")
else:
    logging.warning("GRADIO_FRPC_PATH is not set")

from playwright.async_api import async_playwright
from PIL import Image
from io import BytesIO
import aiohttp
from bs4 import BeautifulSoup
import urllib.parse
import cv2
import numpy as np
import gradio as gr
import asyncio
import re
import pandas as pd

# 이미지 저장 경로 설정
images_folder = 'naver_map_images'
os.makedirs(images_folder, exist_ok=True)

def convert_naver_map_url(url):
    match = re.search(r'place/(\\d+)', url)
    if match:
        place_id = match.group(1)
        return f'https://pcmap.place.naver.com/place/{place_id}/feed?from=map&fromPanelNum=1'
    else:
        raise ValueError("Invalid Naver Map URL")

async def fetch_image(session, url):
    async with session.get(url) as response:
        response.raise_for_status()
        img_data = await response.read()
        img = Image.open(BytesIO(img_data))

        if img.mode in ('RGBA', 'P'):
            img = img.convert('RGB')

        return img

async def download_images(url):
    converted_url = convert_naver_map_url(url)

    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page()
        await page.goto(converted_url)
        await page.wait_for_selector('img')

        content = await page.content()
        await browser.close()

    async with aiohttp.ClientSession() as session:
        soup = BeautifulSoup(content, 'html.parser')
        images = soup.find_all('img')

        tasks = []
        for i, img in enumerate(images):
            img_url = img.get('src')
            if img_url:
                task = fetch_image(session, img_url)
                tasks.append(task)

        images = await asyncio.gather(*tasks)

        for i, img in enumerate(images):
            img.save(f"{images_folder}/image_{i+1}.jpg")

def compare_images(img1, img2):
    img1 = np.array(img1)
    img2 = np.array(img2)

    if img1.shape != img2.shape:
        img2 = cv2.resize(img2, (img1.shape[1], img1.shape[0]))

    similarity = np.sum(img1 == img2) / img1.size
    return similarity > 0.9

def gradio_interface(image, urls_file):
    with open(urls_file.name, 'r') as f:
        urls = f.read().splitlines()

    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    tasks = [download_images(url) for url in urls]
    loop.run_until_complete(asyncio.gather(*tasks))

    results = []
    for filename in os.listdir(images_folder):
        if filename.endswith(".jpg"):
            saved_image = Image.open(os.path.join(images_folder, filename))
            is_similar = compare_images(image, saved_image)
            results.append((filename, is_similar))

    return pd.DataFrame(results, columns=["Image", "Is Similar"])

iface = gr.Interface(
    fn=gradio_interface,
    inputs=[gr.Image(type="pil"), gr.File(label="URLs File")],
    outputs=gr.Dataframe(headers=["Image", "Is Similar"]),
    title="Image Similarity Finder",
    description="Upload an image and a file containing URLs (one per line) to find similar images from the downloaded sets.",
)


iface.launch(share=True)
