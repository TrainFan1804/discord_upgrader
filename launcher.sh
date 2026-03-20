#!/bin/bash

BASE_DIR="$HOME/test"
APP_DIR="$BASE_DIR/app"
TEMP_DIR="$BASE_DIR/temp"

DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=tar.gz"

mkdir -p "$APP_DIR" "$TEMP_DIR"

# follow redirect to URL for newest version
REMOTE_URL=$(curl -sI "$DOWNLOAD_URL" | grep -i location | awk '{print $2}' | tr -d '\r')
EXTENSION=".tar.gz"
REMOTE_VERSION=$(echo "$REMOTE_URL" | grep -oP '([0-9]+)\.tar\.gz'| sed -e "s/$EXTENSION$//")

TARGET_DIR="$APP_DIR/Discord_$REMOTE_VERSION"
DOWNLOAD_ARTIFACT="$TEMP_DIR/Discord_$REMOTE_VERSION.tar.gz"

if [ ! -d "$TARGET_DIR" ]; then

    if [ ! -d "$DOWNLOAD_ARTIFACT" ]; then
        echo "Start download artifact..."
        curl -L "$DOWNLOAD_URL" -o "$DOWNLOAD_ARTIFACT"
    fi

    mkdir -p "$TARGET_DIR"

    tar -xzf "$TEMP_DIR/disord_$REMOTE_VERSION.tar.gz" -C "$TARGET_DIR" --strip-components=1
fi

if [ -f "$TARGET_DIR/Discord" ]; then
    exec "$TARGET_DIR/Discord"
fi
