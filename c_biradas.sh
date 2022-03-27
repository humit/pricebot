#!/bin/bash

OUTPUT=/tmp/biradas.html
URL_PFX=https://www.biradas.com
URL_SFX="/malt-ozu/serbetci-otlu-malt-ozu&sortingstok=1"
IFS_OLD=$IFS

curl -s -k -A 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0' "${URL_PFX}${URL_SFX}" > ${OUTPUT}

while IFS=  read title; do 
 TITLE="$(cat ${OUTPUT} |pup|grep "${title}\" " -A5|head -2|tail -1|tr -s ' '|sed -e 's/\ //')"
 PRICE="$(cat ${OUTPUT} |pup|grep "${title}\" " -A5|head -5|tail -1|tr -s ' '|sed -e 's/\ //' -e 's/TL//'|tr -d ' ')"
 HREF="${URL_PFX}/${title}"
 echo "$(gdate +%Y-%m-%d\ %H:%M:%S.%3N);${TITLE};${PRICE};${HREF}"
done< <(cat ${OUTPUT} |pup|grep urun-title|cut -d\" -f2|cut -d/ -f3)|\
sort -u|\
sort -t\; -k 2 -n

IFS=$IFS_OLD
