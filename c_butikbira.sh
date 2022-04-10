#!/bin/bash

OUTPUT=/tmp/butikbira.html
URL_PFX=https://www.butikbira.com
URL_SFX=/collections/bira-kitleri
IFS_OLD=$IFS

curl -s -k -A 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0' "${URL_PFX}${URL_SFX}" > ${OUTPUT}

while IFS= read link; do 
 HREF="${URL_PFX}${link}"
 PRICE=$(grep ${link} ${OUTPUT}| pup '.money text{}'|tr ',' '.')
 TITLE=$(grep ${link} ${OUTPUT}| pup '.title text{}')
 echo "$(date +%Y-%m-%d\ %H:%M:%S.%3N);${TITLE};${PRICE};${HREF}"
done< \
<(grep current_price ${OUTPUT} |\
 elinks -dump|awk -Ffile:// '/file:/ {print $2}')|\
sort -u|\
sort -t\; -k 2 -n

IFS=$IFS_OLD
