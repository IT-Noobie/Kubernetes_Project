#/bin/bash

if [ $# -gt 2 || $# -lt 2 ]
then
    echo 'Arguments parsing error'
    exit 1
fi
# Stores username and password received by ssh connection
$username = $1
$password = $2

# Create users folders
mkdir /home/noprv/$username
mkdir /home/noprv/$username/certs

# Create user specifying directory, group and shell
useradd -d /home/noprv/$username -s /bin/bash -G noprv $username

# Creates user certificates and context for Kubernetes
cd /home/nopvr/$username
kubectl create rolebinding noPRV --role noPRV-role --user ${username} -n application
openssl genrsa -out ${username}.key 2048
openssl req -new -key ${username}.key -out ${username}.csr -subj "/CN=${username}/O=user"
openssl x509 -req -in ${username}.csr -CA /home/zeus/certs/ca.crt -CAkey /home/zeus/certs/ca.key -CAcreateserial -out ${username}.crt -days 10000
kubectl config set-credentials ${username} --client-certificate=./${username}.crt --client-key=./${username}.key
kubectl config set-context ${username}-context --cluster=kubernetes --namespace=default --user=${username}  
# Applies user context to the user
echo $password | su $username --stdin
kubectl config use-context $username-context

# Copies all the templates to username folder
cp -r /home/zeus/templates /home/noprv/$username/

