for z in Asia/Manila Asia/Saigon Asia/Yekaterinburg Asia/Tbilisi Europe/Moscow UTC America/New_York America/Los_Angeles
do
	printf "%-16s" "$(echo $z | awk -F'/' '{print $NF}')"
	TZ=$z date "+%H:%M %z %Z"
done