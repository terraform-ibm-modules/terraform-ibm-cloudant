#!/bin/bash
# This will create and replicate cloudant databse from Primary site to DR site.
#

if [ "$#" -eq 7 ] || [ "$#" -eq 11 ]; then
CLOUDANT_DR_PROVISION=$1
DATABASE_NAME=$2
CLOUDANT_PARTITIONED=$3
CLOUDANT_PRI_HOST=$4
CLOUDANT_PRI_USER=$5
CLOUDANT_PRI_PASS=$6
CLOUDANT_PRI_KEY=$7
CLOUDANT_DR_HOST=$8
CLOUDANT_DR_USER=$9
CLOUDANT_DR_PASS=${10}
CLOUDANT_DR_KEY=${11}
else
	echo "Error check the variables passed in"
    exit
fi

echo "Creating Primary and DR site databases... "
DBURL_PRI="https://${CLOUDANT_PRI_USER}:${CLOUDANT_PRI_PASS}@${CLOUDANT_PRI_HOST}/${DATABASE_NAME}?partitioned=$CLOUDANT_PARTITIONED"
DBURL_DR="https://${CLOUDANT_DR_USER}:${CLOUDANT_DR_PASS}@${CLOUDANT_DR_HOST}/${DATABASE_NAME}?partitioned=$CLOUDANT_PARTITIONED"
dbstatus_pri=$(curl -w "%{http_code}" -X PUT $DBURL_PRI -g -s -o /dev/null)
# code 201 : database created successfully
# code 412 : database already exists
# code 400 : invalid database name
if [ $dbstatus_pri -eq 201 ]; then
    echo "Primary database created successfuly.."
	if [ "$CLOUDANT_DR_PROVISION" == "true" ]; then
		dbstatus_dr=$(curl -w "%{http_code}" -X PUT $DBURL_DR -g -s -o /dev/null)
	 	if [ "$dbstatus_dr" -eq 201 ]; then
	    	echo " DR site database created successfuly"
		 	dbstatus="complete"
	 	else
        	echo " DR site databse not created "
	 	fi
	fi
else
    echo "primary database not created"
	exit
fi

if [ "$dbstatus" = "complete" ]; then
	echo "Setup replication from primary to DR site.."
	echo "Creating _replicator database.."
	curl -X PUT "https://${CLOUDANT_PRI_USER}:${CLOUDANT_PRI_PASS}@${CLOUDANT_PRI_HOST}/_replicator" -H 'Content-type:application/json' -g

	echo "Setting up replication document.."
	curl -X POST "https://${CLOUDANT_PRI_USER}:${CLOUDANT_PRI_PASS}@${CLOUDANT_PRI_HOST}/_replicator" -H 'Content-type:application/json' -d '{"_id":"'${DATABASE_NAME}'", "create_target":false, "source":{"url":"https://'${CLOUDANT_PRI_HOST}'/'${DATABASE_NAME}'", "auth":{"iam":{"api_key":"'${CLOUDANT_PRI_KEY}'"}}}, "target":{"url":"https://'${CLOUDANT_DR_HOST}'/'${DATABASE_NAME}'", "auth":{"iam":{"api_key":"'${CLOUDANT_DR_KEY}'"}}}, "continuous":true}' -g

	echo  "Setup replication from DR to primary site.."
	echo "Creating _replicator database.."
	curl -X PUT "https://${CLOUDANT_DR_USER}:${CLOUDANT_DR_PASS}@${CLOUDANT_DR_HOST}/_replicator" -H 'Content-type:application/json' -g

	echo "Setting up replication document.."
	curl -X POST "https://${CLOUDANT_DR_USER}:${CLOUDANT_DR_PASS}@${CLOUDANT_DR_HOST}/_replicator" -H 'Content-type:application/json'  -d '{"_id":"'${DATABASE_NAME}'", "create_target":false, "source":{"url":"https://'${CLOUDANT_DR_HOST}'/'${DATABASE_NAME}'", "auth":{"iam":{"api_key":"'${CLOUDANT_DR_KEY}'"}}}, "target":{"url":"https://'${CLOUDANT_PRI_HOST}'/'${DATABASE_NAME}'", "auth":{"iam":{"api_key":"'${CLOUDANT_PRI_KEY}'"}}}, "continuous":true}' -g

	echo "All done"
fi