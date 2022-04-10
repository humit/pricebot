#!/bin/bash

PRICES="fiyatlar.csv"
P_HTML="fiyatlar.html"
SQLTDB="fiyatlar.sqlite"
LOGFILE="pricebot.log"

/bin/rm -f ${PRICES}

function mk_log()
{
    echo "`date '+%m/%d %H:%M:%S'` $1" | tee -a ${LOGFILE}
}

# Run all crawlers
run_crawlers(){
 for script in c_biramarket*.sh; do
 mk_log " + running ${script}"
  . ./${script} >> ${PRICES}
 done
}

# Import CSV into sqlite
import_csv(){
 mk_log "Importing ${PRICES} into ${SQLTDB}"
 sqlite3 -batch ${SQLTDB} <<EOF
.separator ";"
.import ${PRICES} fiyatlar
EOF
}

write_charts(){
mk_log " + generating charts"
while IFS= read -r name; do
 # Cleanup extra spaces
 name=$(echo $name|tr -s \ |sed -e 's/^ //')
 echo ${name}
 sqlite3 ${SQLTDB} "SELECT date, price FROM fiyatlar WHERE name like '%${name}%'"
done< <(sqlite3 ${SQLTDB} 'SELECT name FROM fiyatlar'|sort | uniq)
#done< <(sqlite3 ${SQLTDB} 'SELECT name FROM fiyatlar'|sort | uniq -c|sort -nr)
}

run_crawlers
import_csv
write_charts
