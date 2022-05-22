#/bin/bash
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color
username=$USER
deployed=()

# Changes deploy templates for user specific name templates
deploysList=($(ls /home/noprv/${username}/templates | sed -e 's/\-deploy.yaml$//'))
for deploy in "${deploysList[@]}"
do
  sed -i -e "s/  name: user-deployment/  name: ${username}-${deploy}-deployment/" -e "s/      app: user/      app: ${username}-${deploy}/"  templates/${deploy}-deploy.yaml
done

# Makes the user the ability to initialize two differents Pods
for i in {1..2};
do
    # Outputs the selection of applications avalaibles
    PS3=$'\e[1;32mSELECT WHAT YOU WANT TO TEST (0 -> Finish):\e[0m '
    select application in ${deploysList[@]}
    do
        if [ $REPLY -le ${#deploysList[@]} ] && [ $REPLY -gt 0 ]
        then
                echo -e "${GREEN}SELECTED APPLICATION IS: ${NC} ${application}"
        #       kubectl apply -f templates/${application}-deploy.yaml
                deployed+=(${application})
                break
        elif [ $REPLY -eq 0 ]
        then
               break
        else
                echo -e "${RED}SELECTED OPTION IS NOT VALID. PLEASE CHOOSE A VALID OPTION ${NC}"
        fi
    done
done

# Outputs user pods
for application in "${deployed[@]}"
do
        kubectl --context=${username}-context get pod -l app=${username}-${application} -n application
done

# Deletes all templates to make impossible for the user to deploy another time
trap 'rm -rf /home/noprv/${username}/templates' EXIT
