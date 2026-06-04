#!/bin/bash

Kilon() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mخطأ: الاستخدام الصحيح هو:\e[0m"
        echo "kilon [الجودة] [الرابط]"
        echo "مثال: kilon 720p \"الرابط\""
        return 1
    fi

    local quality=$1
    local url=$2
    local base_dir="/sdcard/Download"

    if [ "$quality" == "mp3" ]; then
        local target_dir="$base_dir/Kilon_Music"
        mkdir -p "$target_dir"
        cd "$target_dir" || return

        echo -e "\e[32mجاري تنزيل الصوت وحفظه في مجلد Kilon_Music...\e[0m"
        yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata "$url"

        # أمر ذكي لتحديث مكتبة الموسيقى في الأندرويد فوراً
        termux-media-scan "$target_dir"/* 2>/dev/null
    else
        local target_dir="$base_dir/Kilon_Videos"
        mkdir -p "$target_dir"
        cd "$target_dir" || return

        echo -e "\e[32mجاري تنزيل الفيديو وحفظه في مجلد Kilon_Videos...\e[0m"

        if [ "$quality" == "1080p" ]; then
            yt-dlp -f "bestvideo[height<=1080]+bestaudio/best" --merge-output-format mp4 "$url"
        elif [ "$quality" == "720p" ]; then
            yt-dlp -f "bestvideo[height<=720]+bestaudio/best" --merge-output-format mp4 "$url"
        elif [ "$quality" == "480p" ]; then
            yt-dlp -f "bestvideo[height<=480]+bestaudio/best" --merge-output-format mp4 "$url"
        elif [ "$quality" == "360p" ]; then
            yt-dlp -f "bestvideo[height<=360]+bestaudio/best" --merge-output-format mp4 "$url"
        else
            echo -e "\e[33mجودة غير معروفة، سيتم التنزيل بأعلى جودة متوفرة بصيغة mp4...\e[0m"
            yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 "$url"
        fi

        termux-media-scan "$target_dir"/* 2>/dev/null
    fi
}

