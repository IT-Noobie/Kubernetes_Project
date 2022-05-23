#/bin/bash

if [ $# -ne 3 ]
then
    echo 'Arguments parsing error'
    exit 1
fi

# Stores username and password received by ssh connection
godPassword=$2

username=$3
password=$4

# Create users folders
mkdir /home/noprv/${username}
mkdir /home/noprv/${username}/certs

# Create user specifying directory, group and shell
echo ${godPassword} | sudo -S useradd -d /home/noprv/${username} -s /bin/bash -G noprv-users $username

# Creates user certificates and context for Kubernetes
cd /home/noprv/${username}

kubectl create rolebinding noprv_${RANDOM} --role noprv-role --user ${username} -n application
openssl genrsa -out ${username}.key 2048
openssl req -new -key ${username}.key -out ${username}.csr -subj "/CN=${username}/O=user"
openssl x509 -req -in ${username}.csr -CA /home/zeus/certs/ca.crt -CAkey /home/zeus/certs/ca.key -CAcreateserial -out ${username}.crt -days 10000
kubectl config set-credentials ${username} --client-certificate=./${username}.crt --client-key=./${username}.key
kubectl config set-context ${username}-context --cluster=kubernetes --namespace=default --user=${username}

# Copies all the templates to username folder
cp -r /home/zeus/templates /home/noprv/${username}/
