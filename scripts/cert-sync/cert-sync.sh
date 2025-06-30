#!/bin/bash

# Configuration
SRC_DIR="/opt/docker/nginx-proxy/data/custom_ssl/fun-pumpkins.net"
DEST_DIR="/opt/docker/nginx-proxy/data/custom_ssl/npm-1"
TIMESTAMP_FILE="/opt/scripts/last_cert_sync"
SYNC_LOG="/opt/scripts/sync_log"

if [ ! -f "$SYNC_LOG" ]; then
   echo "Creating log file ..." > "$SYNC_LOG"
fi

if [ ! -f "$TIMESTAMP_FILE" ]; then
#    echo "Creating timestamp file..." >> "$SYNC_LOG"
    date -d '2025-01-01' +%s > "$TIMESTAMP_FILE"
fi

# Get the last sync time
LAST_SYNC=$(cat "$TIMESTAMP_FILE")

# Current time for next sync
CURRENT_TIME=$(date +%s)

# Find and copy updated files
echo "Looking for files modified since $(date -d @$LAST_SYNC)..."  >> "$SYNC_LOG"
find "$SRC_DIR" -type f -newermt "@$LAST_SYNC" | while read -r FILE; do
    REL_PATH="${FILE#$SRC_DIR/}"
    BASENAME=$(basename "$REL_PATH")
    EXTENSION="${BASENAME##*.}"
    FILENAME="${BASENAME%.*}"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    # If no extension, don't append dot
    if [ "$FILENAME" == "key" ]; then
        NEW_NAME="privkey.${EXTENSION}"

    elif [ "$FILENAME" == "fullchain" ]; then
        NEW_NAME="fullchain.${EXTENSION}"

    else
        NEW_NAME="${FILENAME}.${EXTENSION}"
    fi

    DEST_PATH="$DEST_DIR/$NEW_NAME"
    cp -f "$FILE" "$DEST_PATH"
    echo "Copied and renamed: $FILE → $DEST_PATH" >> "$SYNC_LOG"
done

# Update the timestamp
echo "$CURRENT_TIME" > "$TIMESTAMP_FILE"