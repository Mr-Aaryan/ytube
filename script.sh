#!/bin/bash

dependencies=("ffmpeg" "yt-dlp")

# Function to check if dependencies are installed
check_dependencies() {
    for dependency in "${dependencies[@]}"; do
        if ! command -v "$dependency" &> /dev/null; then
            sudo pacman -S "$dependency"  # Install the missing dependency
        fi
    done
}

# Function to create directory if it doesn't exist
create_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
}

# Check for required dependencies
check_dependencies

# Display options to the user
printf "Choose an option\n"
printf "1. Youtube Video/Playlist\n2. Youtube Playlist (adds indexing before name)\n3. Youtube Audio (playlist works)\n"
read -r option

# Handle the user input
case $option in 
    1)
        echo "Enter video/playlist URL"
        read -r video
        echo "Enter the path (default = HOME/Downloads/ytube)"
        read -r save_path
        if [ -z "$save_path" ]; then
            save_path="$HOME/Downloads/ytube"
        fi
        create_directory "$save_path"
        echo "Saving to: $save_path"
        yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o "$save_path/%(title)s.%(ext)s" "$video"
        ;;
    2)
        echo "Enter playlist URL"
        read -r playlist
        echo "Enter the path (default = HOME/Downloads/ytube)"
        read -r save_path
        if [ -z "$save_path" ]; then
            save_path="$HOME/Downloads/ytube"
        fi
        create_directory "$save_path"
        echo "Saving to: $save_path"
        yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -i -o "$save_path/%(playlist_index)s - %(title)s.%(ext)s" "$playlist"
        ;;
    3)
        echo "Enter video/playlist URL"
        read -r audio
        echo "Enter the path (default = HOME/Downloads/ytube)"
        read -r save_path
        if [ -z "$save_path" ]; then
            save_path="$HOME/Downloads/ytube"
        fi
        create_directory "$save_path"
        echo "Saving to: $save_path"
        yt-dlp -f 'bestaudio[ext=m4a]' --extract-audio --audio-format mp3 --audio-quality 0 -o "$save_path/%(title)s.%(ext)s" "$audio"
        ;;
    *)
        echo "Unspecified option"
    ;;
esac
