#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
set -o xtrace

if test -e /run/media/me/$2
then
	umount /run/media/me/$2
	cryptsetup luksClose $2
	rm -rf /run/media/me/$2
else
	cryptsetup luksOpen $1 $2
	mkdir -p /run/media/me/$2
	mount /dev/mapper/$2 /run/media/me/$2
fi