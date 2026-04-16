# Allow modification of files and download via pkg install ffmpeg
ffmpeg -i "/storage/emulated/0/Download/videoplayback.mp4" -c:v libx264 -crf 26 -r 5 -vf "setpts=0.1*PTS,fps=15" "/sdcard/Download/newMP4Video.mp4"
