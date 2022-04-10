#!/bin/bash

OUTPUT=/tmp/vino.html
URL_PFX="https://vinomarket.com.tr"
URL_SFX="/kategori/smo-kitleri?stoktakiler=1"
IFS_OLD=$IFS

curl -s -L -A 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0' "${URL_PFX}${URL_SFX}" > ${OUTPUT}

while IFS= read o; do
 HREF=$(grep -w "${o}" ${OUTPUT}|head -1|awk -F\" '/href=/ {print $2}')
 PRICE=$(grep -A4 -w ">${o}<" ${OUTPUT}|grep ₺| tr -s '\t' ' '|tr -d ' '|tr -d '₺'|tr ',' '.')
 echo "$(date +%Y-%m-%d\ %H:%M:%S.%3N);${o};${PRICE};${URL_PFX}${HREF}"
done< \
<(cat ${OUTPUT} | \
pup 'div[class="showcase-title"] text{}'|\
grep Özü|sort -u) |\
sort -t\; -k 2 -n

IFS=$IFS_OLD
