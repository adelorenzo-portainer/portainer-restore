## Demo of a restore process using a simple hearbeat script and the Portainer API

This demonstration shows how fast and straightforward it is to restore a Portainer instance running on a kubernetes cluster to a new cluster using the Portainer API. The `portainer_hb.sh` is a simple bash script that checks if the main Portainer server is running by simmply doing an API call without needing authorization. If the result output does not respond to the typical pattern of the API call the script then deploys a new Portainer instance and restores a backup from an S3 compatible server, in this case MinIO.

![HA Portainer](https://github.com/adelorenzo-portainer/portainer-restore/assets/81579885/c57f6cd9-a70c-42d2-b671-85adb0488a36)

Given that the restore process includes all of the Portainer settings, there is no disruption of the Portainer application once it is redeployed on the backup kubernetes cluster. On a real production environment this would include all of the endpoints, registry settings, authentication, etc... configured on the Portainer server.

Below is a quick video demonstrating the automated restore process in action using the example `portainer_hb.sh` bash script. The main Portainer server is running on IP address 192.168.10.171 and the backup is running on the IP address 192.168.10.176

https://github.com/adelorenzo-portainer/portainer-restore/assets/81579885/f04abe77-5736-4562-9d36-8d88709f8d9e
