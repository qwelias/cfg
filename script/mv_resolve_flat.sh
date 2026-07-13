#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
set +o histexpand
shopt -s globstar
shopt -s nullglob
# set -o xtrace

from="${1}"
to="${2}"

rnghex() {
	openssl rand -hex 4
}

findfiles() {
	find "${from}" -type f -printf "%P\n"
}

getfilename() {
	echo "${1%.*}"
}

getextname() {
	echo "${1##*.}"
}

cleanname() {
	echo "$1" | sed 's/[^a-zA-Z0-9]/_/g' 
	# echo "${1//[\,\-+! '\"'\`\'\/\(\)’]/_}"
}

while read -r file
do
	# echo $file
	filename=$(cleanname "${file%.*}")
	extname="${file##*.}"
	path="${to}/${filename}.${extname}"
	if test -f "${path}"
	then path="${to}/${filename}_$(rnghex).${extname}"
	fi
	echo mv
	echo "$from/$file"
	echo "$path"
	mv "$from/$file" "$path"
done < <(findfiles)

	