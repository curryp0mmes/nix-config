#!/usr/bin/env bash

# Ignore events where clipboard was emptied or cleared
[ "$CLIPBOARD_STATE" != "data" ] && exit 0

id_file="${XDG_RUNTIME_DIR:-/tmp}/clip-notify.id"
id=$(cat "$id_file" 2>/dev/null || echo 0)

if [ "$1" = "image" ]; then
    msg="🖼️ Image"
else
    raw=$(head -c 51 | tr "\n\r\t" "   " | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')
    [ -z "$raw" ] && exit 0
    if [ ${#raw} -gt 50 ]; then
        msg="${raw:0:47}..."
    else
        msg="$raw"
    fi
fi

new_id=$(notify-send -p -r "$id" -t 1200 -e -a Clipboard -- "Copied" "$msg")
echo "$new_id" > "$id_file"
