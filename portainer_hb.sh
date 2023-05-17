#!/usr/bin/bash

clear

# Check if the main Portainer server is running using an API call. An 'Unauthorized' reply means it is. No authentication is needed.
while true
do
portainer_up=`curl --silent --insecure -X GET https://192.168.10.171:30779/api/endpoints | jq -r '.details'`
if [ "$portainer_up" = "Unauthorized" ]; then
        echo -ne '⚡ Portainer is up\r'
else
        break
fi
sleep 5
done

# Deploy a new Portainer instance
kubectl apply -n portainer -f https://downloads.portainer.io/ee2-18/portainer.yaml
echo
echo 'Deploying Portainer server'
echo

# Check if Portainer is running before applying the restore
while true
do
portainer_running=`kubectl get po -n portainer | tail -1 | awk '{print $3}'`
if [ "$portainer_running" != "Running" ]; then
        echo -ne ' ⚡ Portainer is Not Running yet\r'
else
        break
fi
sleep 1
done

sleep 5

# Restore the Portainer backup from an S3 bucket
echo
echo 'Restoring Portainer backup'

curl -X POST \
--insecure \
--header 'Content-Type: application/json' \
--url 'https://192.168.10.176:30779/api/backup/s3/restore' \
--data '{"accessKeyID": "portainer", "bucketName": "kubernetes1",  "filename": "portainer-backup_2023-05-17_00-55-00.tar.gz",  "password": "",  "region": "us-east-1",  "s3CompatibleHost": "http://192.168.10.1:9002",  "secretAccessKey": "CHANGEME"}'

echo
echo 'Portainer restored'
