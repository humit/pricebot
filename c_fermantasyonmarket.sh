#!/bin/bash

OUTPUT="/tmp/fermantasyonmarket.html"
URL_PFX="https://www.fermantasyonmarket.com"
URL_SFX="/kategori/evde-bira-yapma-kitleri?stoktakiler=1"
IFS_OLD=$IFS

curl -s -L -A 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0' "${URL_PFX}${URL_SFX}" > ${OUTPUT}

while IFS= read o; do
 HREF=$(grep -w "${o}" ${OUTPUT}|head -1|awk -F\" '/href=/ {print $2}')
 PRICE=$(grep -A4 -w ">${o}<" ${OUTPUT}|grep " TL"| tr -s '\t' ' '|tr -d ' '|sed -e 's/TL//'|tr ',' '.')
 echo "${o};${PRICE};${URL_PFX}${HREF}"
done< \
<(cat ${OUTPUT} | \
pup 'div[class="showcase-title"] text{}'|\
grep Özü|sort -u) |\
sort -t\; -k 2 -n

IFS=$IFS_OLD
