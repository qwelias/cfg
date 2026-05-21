#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

grep 'cpu ' /proc/stat > /tmp/cpustat
c1=$(awk '{print $1}' /tmp/cpustat)
c2=$(awk '{print $2}' /tmp/cpustat)
c3=$(awk '{print $3}' /tmp/cpustat)
c4=$(awk '{print $4}' /tmp/cpustat)
c5=$(awk '{print $5}' /tmp/cpustat)
c6=$(awk '{print $6}' /tmp/cpustat)
c7=$(awk '{print $7}' /tmp/cpustat)
c8=$(awk '{print $8}' /tmp/cpustat)
c9=$(awk '{print $9}' /tmp/cpustat)
c10=$(awk '{print $10}' /tmp/cpustat)
c11=$(awk '{print $11}' /tmp/cpustat)

ct=$(( $c2+$c3+$c4+$c5+$c6+$c7+$c8+$c9+$c10+$c11 ))
ci=$(( $c6 + $c5 ))

if [ -f '/tmp/cpuprev' ]; then
    cpt=$(awk '{print $1}' /tmp/cpuprev)
    cpi=$(awk '{print $2}' /tmp/cpuprev)

    cdt=$(( $cpt - $ct ))
    cdi=$(( $cpi - $ci ))

    cpup=$(echo "scale=2; 100 * (1 - $cdi / $cdt)" | bc | awk -F'.' '{print $1}')
else
    cpup='..'
fi
echo "$ct $ci" > /tmp/cpuprev

cat /proc/meminfo > /tmp/meminfo
mt=$(grep MemTotal /tmp/meminfo | awk '{print $2}')
ma=$(grep MemAvail /tmp/meminfo | awk '{print $2}')
mu=$(( $mt - $ma ))
memp=$(echo $(( 100 * $mu / $mt )))

if [[ $memp -gt 90 ]]
then printf '\x09'
elif [[ $memp -gt 85 ]]
then printf '\x02'
fi
printf '  ' 
printf "%02d" $cpup
printf ' ~ '
printf "%02d" $memp
printf '  '