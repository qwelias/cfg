#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

# This is bound to Shift+PrintScreen by default, requires maim. It lets you
# choose the kind of screenshot to take, including copying the image or even
# highlighting an area to copy. scrotcucks on suicidewatch right now.

# variables
dir=~/Pictures/Screenshots
output="$(date '+%y%m%d-%H%M-%S').png"
xclip_cmd="xclip -sel clip -t image/png"
ocr_cmd="xclip -sel clip"
tmpfull=/tmp/maimfull.png
tmpocr=/tmp/maimocr.png

cleanup() {
	kill %1
	rm $tmpfull || true
	rm $tmpocr || true
}

maim $tmpfull
feh -x -F $tmpfull &
trap 'cleanup' ERR EXIT

if [[ $1 == ss ]]
then maim -u -s | tee $dir/pic-selected-$output | ${xclip_cmd}
elif [[ $1 == ocr ]]
then maim -u -s > $tmpocr && tesseract $tmpocr - -l eng | ${ocr_cmd}
fi

# case "$(printf "a selected area\\ncurrent window\\nfull screen\\na selected area (copy)\\ncurrent window (copy)\\nfull screen (copy)\\ncopy selected image to text" | dmenu -l 7 -i -p "Screenshot which area?")" in
#     "a selected area") maim -u -s | tee "${dir}"/pic-selected-"${output}" | ${xclip_cmd} ;;
#     "current window") maim -B -q -d 0.2 -i "$(xdotool getactivewindow)" | tee "${dir}"/pic-window-"${output}" | ${xclip_cmd} ;;
#     "full screen") maim -q -d 0.2 | tee "${dir}"/pic-full-"${output}" | ${xclip_cmd} ;;
#     "copy selected image to text") tmpfile=$(mktemp /tmp/ocr-XXXXXX.png) && maim -u -s > "$tmpfile" && tesseract "$tmpfile" - -l eng | ${ocr_cmd} && rm "$tmpfile" ;;
# esac
