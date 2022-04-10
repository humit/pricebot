#!/bin/bash

OUTPUT=/tmp/biramarket.html
URL_PFX=https://www.biramarket.com
URL_SFX="/Malty_setleri?permission=1"
IFS_OLD=$IFS

curl -s -k -A 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0' "${URL_PFX}${URL_SFX}" > ${OUTPUT}

while IFS= read id; do
 TITLE=$(grep "\"productName detailUrl\" data-id=\"${id}\"" ${OUTPUT} |cut -d\" -f 6)
 PRICE=$(grep "\"productName detailUrl\" data-id=\"${id}\"" ${OUTPUT} -A4 | awk -F₺ '/₺/ {print $2}'|tr ',' '.')
 HREF=${URL_PFX}$(grep "\"productName detailUrl\" data-id=\"${id}\"" ${OUTPUT}|cut -d\' -f2)
 echo "$(date +%Y-%m-%d\ %H:%M:%S.%3N);${TITLE};${PRICE};${HREF}"
done< <(grep "id\":\ " ${OUTPUT}|awk -F\" '{print $4}')|\
sort -u|\
sort -t\; -k 2 -n

IFS=$IFS_OLD
