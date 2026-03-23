#!/bin/bash

set -euo pipefail

BASE_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
APP_DIR="$BASE_DIR/app"
TEMP_DIR="$BASE_DIR/temp"

DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=tar.gz"

mkdir -p "$APP_DIR" "$TEMP_DIR"

# follow redirect to URL for newest version
REMOTE_URL=$(curl -sI "$DOWNLOAD_URL" | grep -i location | awk '{print $2}' | tr -d '\r')
EXTENSION=".tar.gz"
REMOTE_VERSION=$(echo "$REMOTE_URL" | grep -oP 'discord-\d\.\d\.([0-9]+)\.tar\.gz'| sed -e "s/$EXTENSION$//")

TARGET_DIR="$APP_DIR/$REMOTE_VERSION"
DOWNLOAD_ARTIFACT="$TEMP_DIR/$REMOTE_VERSION.tar.gz"

if [ ! -f "$DOWNLOAD_ARTIFACT" ]; then
    echo "Start dowloading Discord version $REMOTE_VERSION..."
    curl -L --fail "$DOWNLOAD_URL" -o "$DOWNLOAD_ARTIFACT"
else
    echo "Found $DOWNLOAD_ARTIFACT in folder, skip download"
fi

if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "Start extracting"
    tar -xzf "$TEMP_DIR/$REMOTE_VERSION.tar.gz" -C "$TARGET_DIR" --strip-components=1
fi

if [ -f "$TARGET_DIR/Discord" ]; then
    exec "$TARGET_DIR/Discord"
fi
