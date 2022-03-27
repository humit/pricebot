#!/bin/bash

PRICES="fiyatlar.csv"
P_HTML="fiyatlar.html"

/bin/rm -f ${PRICES}

# Run all crawlers
for script in c_*.sh; do
 . ./${script} >> ${PRICES}
done

# Sort csv file
sort -n -t\; -k 2 ${PRICES} > ${PRICES}.tmp
mv ${PRICES}.tmp ${PRICES}

# Create href links
#while IFS= read line; do 
# URL=$(echo ${line}|cut -d\; -f3)
# sed -i .bak -e "s#$URL#\<a href=$URL\>$URL\</a\>#" ${PRICES}
#done < ${PRICES}

# csv to html
#{
# echo "<table>"
# date
# echo "<hr>"
# echo "<table>"
# echo "KIT;FIYAT;URL" | \
#    sed -e 's/^/<tr><th>/' -e 's/;/<\/th><th>/g' -e 's/$/<\/th><\/tr>/'
# tail -n +2 ${PRICES} | \
#    sed -e 's/^/<tr><td>/' -e 's/;/<\/td><td>/g' -e 's/$/<\/td><\/tr>/'
# echo "</table>"
#} > ${P_HTML}
