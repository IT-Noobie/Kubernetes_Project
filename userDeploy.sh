#/bin/bash
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Changes deploy templates for user specific name templates
deploysList=($(ls /home/noprv/$username/templates | sed -e 's/\-deploy.yaml$//'))
for deploy in "${deploysList[@]}"
do
  sed -i -e "s/  name: user-deployment/  name: $username-$deploy-deployment/" -e "s/      app: user/      app: $username-$deploy/"  $deploy-application.yaml
done

# Makes the user the ability to initialize two differents Pods
for i in {1..2};
do
    # Outputs the selection of applications avalaibles
    select application in ${deploysList[@]}
    do
    if [ $REPLY -le ${#deploysList[@]} ] && [ $REPLY -gt 0 ] 
    then
        echo -e "${GREEN}SELECTED APPLICATION IS: ${NC} ${application}"
        kubectl apply -f $application-deploy.yaml
        break
    else
        echo -e "${RED}SELECTED OPTION IS NOT VALID. PLEASE CHOOSE A VALID OPTION ${NC}"  fi
    done
done

# Outputs user pods
kubectl get pod -l app=$username -n application
#kubectl --context=paco-context exec nginx-deployment-f7ccf9478-nx62z -n application -it -- /bin/bash

# Deletes all templates to make impossible for the user to deploy another time
trap 'rm -rf /home/noprv/${username}/templates' EXIT