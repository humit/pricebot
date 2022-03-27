#!/bin/bash

PRICES="fiyatlar.csv"
P_HTML="fiyatlar.html"
SQLTDB="fiyatlar.sqlite"

/bin/rm -f ${PRICES}

# Run all crawlers
run_crawlers(){
 for script in c_*.sh; do
  . ./${script} >> ${PRICES}
 done
}

# Import CSV into sqlite
import_csv(){
 echo "Importing ${PRICES} into ${SQLTDB}"
 sqlite3 -batch ${SQLTDB} <<EOF
.separator ";"
.import ${PRICES} fiyatlar
EOF
}

run_crawlers
import_csv
