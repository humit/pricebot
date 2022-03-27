#!/bin/bash

OUTPUT=/tmp/egemalt.html
OUTPRD=/tmp/egemalt_prd.html
URL_PFX=https://egemalt.com
URL_SFX="/bandit-crow/"
IFS_OLD=$IFS
UA="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"

curl -s -k -A "${UA}" "${URL_PFX}${URL_SFX}" > ${OUTPUT}

while IFS= read URL; do
 curl -s -k -A "${UA}" "${URL}" > ${OUTPRD}
 TITLE=$(grep og:title ${OUTPRD} |cut -d\" -f4)
 HREF=${URL}
#PRICE=$(grep product:price:amount ${OUTPRD}|cut -d\" -f4|tr '.' ','|xargs printf "%.2f"|tr ',' '.')
 PRICE=$(grep product:price:amount ${OUTPRD}|cut -d\" -f4)
 echo "$(gdate +%Y-%m-%d\ %H:%M:%S.%3N);${TITLE};${PRICE};${HREF}"
done< <(cat ${OUTPUT} | pup '.elementor-image-box-wrapper'|grep href|cut -d\" -f2| sort -u)|\
sort -u|\
sort -t\; -k 2 -n

IFS=$IFS_OLD
