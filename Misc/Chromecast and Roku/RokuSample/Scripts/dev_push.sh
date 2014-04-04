#/bin/bash

IP_ADDR=$1
ZIPFILE=$2
USERNAME="rokudev"
PASSWORD="dev1234"

if [ -z "$IP_ADDR" ]
then
	IP_ADDR="192.168.1.114"
fi

if [ -z "$ZIPFILE" ]
then
	ZIPFILE="../Artifacts/roku_deployment.zip"
fi

echo "Target Roku IP Address is $IP_ADDR"
echo "Zip filename is $ZIPFILE"

rm "$ZIPFILE"
zip -9 -r "$ZIPFILE" . 
ls -l "$ZIPFILE"
curl -F archive=@"$ZIPFILE" -F mysubmit=Replace --digest --user "$USERNAME":"$PASSWORD" "http://$IP_ADDR/plugin_install"
