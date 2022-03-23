#!/bin/bash

OUTPUT=/tmp/kedikoy.html
OUTDMP=/tmp/kedikoy.dump
URL_PFX=https://www.kedikoy.com.tr
URL_SFX=/serbetci-otlu-malt-ozu
IFS_OLD=$IFS

curl  -L -s -k -A 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0' "${URL_PFX}${URL_SFX}" > ${OUTPUT}
elinks -dump ${OUTPUT} >  ${OUTDMP}

while IFS= read id; do 
 TITLE=$(echo "{ \"items\": [ $(grep -B1 -A9 "\"id\": \"${id}\"" ${OUTPUT} |tr "\'" "\""| sed "s/},/}/" ) ] }"|jq '.items[].name'|tr -d '\"')
 PRICE=$(grep "${TITLE}" ${OUTPUT} | grep pure-price | elinks -dump| grep " TL"|awk '{print $1}'|tr ',' '.')
 QTY=$(echo "{ \"items\": [ $(grep -B1 -A9 "\"id\": \"${id}\"" ${OUTPUT} |tr "\'" "\""| sed "s/},/}/" ) ] }"|jq '.items[].quantity')
 HREF=$(grep -A1 "$(grep "${TITLE}" ${OUTDMP}|head -1|tr '[,]' ' '|awk '{print $1}')\." ${OUTDMP} | tail -1|tr -d '\t')
 echo "${TITLE};${PRICE};${HREF}"
done< \
<(grep pure-price ${OUTPUT} | awk -F\' '{print $2}'| sort -u| grep -v ^$)|\
sort -u|\
sort -t\; -k 2 -n

IFS=$IFS_OLD
