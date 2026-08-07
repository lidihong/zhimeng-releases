#!/bin/bash
# 织梦 · macOS 一键安装:自动下载最新版 → 装入应用程序 → 解除隔离 → 打开
set -e
echo "织梦 · 原创小说工作台 — 一键安装"
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then KEY="mac-arm64"; else KEY="mac-x64"; fi
echo "检测到芯片:$ARCH,正在获取最新版本…"
URL=$(curl -fsSL "https://api.github.com/repos/lidihong/zhimeng-releases/releases/latest" \
  | grep "browser_download_url" | grep "$KEY" | grep '\.zip' | head -1 | cut -d '"' -f 4)
if [ -z "$URL" ]; then echo "获取下载地址失败,请稍后再试"; exit 1; fi
TMP=$(mktemp -d)
echo "正在下载安装包…"
curl -fSL --progress-bar -o "$TMP/zhimeng.zip" "$URL"
echo "正在解压…"
unzip -q "$TMP/zhimeng.zip" -d "$TMP"
APP=$(find "$TMP" -maxdepth 1 -name "*.app" | head -1)
if [ -z "$APP" ]; then echo "安装包异常,未找到 App"; exit 1; fi
echo "正在装入「应用程序」…"
rm -rf "/Applications/织梦.app"
mv "$APP" "/Applications/织梦.app"
echo "正在解除安全隔离(避免「应用已损坏」)…"
xattr -dr com.apple.quarantine "/Applications/织梦.app" 2>/dev/null || true
rm -rf "$TMP"
echo "安装完成,正在打开织梦…"
open "/Applications/织梦.app"
