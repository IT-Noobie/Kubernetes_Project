#!/bin/bash
mkdir /home/nopvr/$username
mkdir /home/nopvr/$username/certs
useradd -d /home/nopvr/$username -s /bin/rbash -G nopvr $username
kubectl create rolebinding rolebindingName --role roleName --user userName -n namespaceName
cd /home/nopvr/$username/certs
openssl genrsa -out user.key 2048
openssl req -new -key user.key -out user.csr subj "/CN=alice/O=user"
openssl x509 -req -in alice.csr -CA ca.crt -CAkey ca.key \
-CAcreateserial -out user.crt -days 10000

kubecl config set-credential user --client-certificate=./user.crt --client-key=user.key
kubectl config set-context user-context --cluster=microk8s-cluster --namespace=application --user=
 


/usr/bin/mkdir
/usr/bin/useradd
/usr/bin/kubectl
/usr/bin/openssl
/usr/bin/cd
/usr/bin/kubectl