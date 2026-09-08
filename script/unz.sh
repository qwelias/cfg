name=$(echo "$1" | sed -E 's/\.\w+$//')
echo $name
7z x "$1" -o"$name"