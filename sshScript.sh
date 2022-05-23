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

# Create user specifying directory, group and shell
echo ${godPassword} | sudo -S useradd -d /home/${username} -s /bin/rbash -G zeus -m  $username
mkdir /home/${username}/certs

# Creates user certificates and context for Kubernetes
cd /home/${username}

# Generates rolebinding and certificates. Configures credentials and sets it up
kubectl create rolebinding noprv_${RANDOM} --role noprv-role --user ${username} -n application
openssl genrsa -out ${username}.key 2048
openssl req -new -key ${username}.key -out ${username}.csr -subj "/CN=${username}/O=user"
openssl x509 -req -in ${username}.csr -CA /home/zeus/certs/ca.crt -CAkey /home/zeus/certs/ca.key -CAcreateserial -out ${username}.crt -days 10000
kubectl config set-credentials ${username} --client-certificate=./${username}.crt --client-key=./${username}.key
kubectl config set-context ${username}-context --cluster=kubernetes --namespace=application --user=${username}


# Copies all the templates to username folder
cp -r /home/zeus/scripts/userDeploy.sh /home/${username}
cp -r /home/zeus/templates /home/${username}/
cp -r /home/zeus/bin /home/${username}/
echo ${godPassword} | sudo -S chown -R ${username}:zeus /home/${username}

echo ${godPassword} | sudo -S bash -c 'cat <<EOF >> /home/alicia/.bashrc
alias kubectl="kubectl --context=alicia-context"
PATH=/home/alicia/bin
export PATH
EOF'
