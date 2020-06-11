#!/bin/bash
# Utility Script for built on kubectl for frequent Developer activities
# Draft versin


########################################################################
option=1
env=''
box=''
urlname=''
PROPERTY_FILE=parse.properties



function appListing()
{

clear
echo '------------------------------------------------------------------------------------------------------------------------'
kubectl --kubeconfig=$config get deployments
echo ''
echo -ne 'W h i c h  O n e  Y o u  L i k e  I n  A b o v e  L i s t : '
read deployment

pods=`kubectl --kubeconfig=$config get pods | grep $deployment`

clear
echo '------------------------------------------------------------------------------------------------------------------------'
echo 'application pods '
echo $pods
echo '.'
version=`kubectl --kubeconfig=$config describe deployment $deployment| grep version | head -1 | awk '{print$1}'`
port=`kubectl --kubeconfig=$config get service $deployment  | awk '{print$5}' | cut -d'/' -f1 | tail -1 | cut -d':' -f2`
echo 'version: '$version
echo 'port: '$port


}


appListing


echo ''
while [ true ] ; do 


echo 'O p t i o n s'
echo ''
echo '1. tail live pods logs '
echo '2. login to pod [exec]'
echo '3. scale down app [scale :0]'
echo '4. bounce app [scale 0 -> 1]'
echo '5. edit deployment yaml[edit deployment]'
echo '6. edit service yaml [edit service]'
echo '7. edit configmap yaml [edit configmap]'
echo '8. delete deployment yaml [delete]'
echo '9. delete service yaml [delete]'
echo '10. create secret []'
echo '11. get service/deployment with filter [get ] '
echo '12. reset Environment [retrigger env]'
echo '13. reset Application [] retrigger app'
echo '14. exit '

echo ''
echo -ne 'W h a t  Y o u  A r e  U p  T o  T o d a y , R e v e a l  Y o u r  I n t e n t [ 1 - 15 ] : '
read appotion
if [ $appotion == '1' ] ; then
pods=`kubectl --kubeconfig=$config get pods | grep $deployment'-' | cut -d' ' -f1 `
for pod in $pods ; do
mkdir -p logs/$today/$box/$deployment/
kubectl --kubeconfig=$config logs -f $pod >logs/$today/$box/$deployment/$pod'.log' &
echo 'streaming '$pod
sleep 5
#cygstart logs/$today/$box/$deployment/$pod'.log'

done
#echo 'Want To serach a Pattern ' 
#read pattern

#grep $pattern logs/$today/$box/$deployment/*.log >logs/$today/$box/$deployment/search.log
# cygstart logs/$today/$box/$deployment/search.log


clear
fi

if [ $appotion == '2' ] ; then
  echo enter pod name:
  read pod;
  kubectl --kubeconfig=$config exec -it $pod -- sh
  clear
fi
if [ $appotion == '3' ] ; then
 kubectl --kubeconfig=$config scale  deploy $deployment --replicas=0
#sleep 10
#kubectl scale deploy $deploy --replicas=1
  clear
fi
if [ $appotion == '4' ] ; then
 kubectl --kubeconfig=$config scale  deploy $deployment --replicas=0
 sleep 10
 kubectl --kubeconfig=$config scale deploy $deployment --replicas=1
  clear
fi
if [ $appotion == '5' ] ; then
 kubectl --kubeconfig=$config edit deployment $deployment
  clear
fi
if [ $appotion == '6' ] ; then
 kubectl --kubeconfig=$config edit service $deployment
  clear
fi
if [ $appotion == '7' ] ; then
configmaps=`kubectl --kubeconfig=$config get configmaps | grep $deployment'-'`
 echo 'configmaps '$configmaps
 echo 'enter configmap to edit '
 read configmap 
  kubectl --kubeconfig=$config edit configmap $configmap
  clear
fi
if [ $appotion == '8' ] ; then
kubectl --kubeconfig=$config delete deployment $deployment
clear
fi

if [ $appotion == '9' ] ; then
kubectl --kubeconfig=$config delete service $deployment
clear
fi

if [ $appotion == '10' ] ; then
echo enter name
read name
echo enter key
read key
echo namespace[abc.def]
read ns
echo deployment tag
read dt
echo application tag
read at
echo playbook tag
read pt
echo '######################### DEPLOYMENT'

kubectl --kubeconfig=$config create secret generic $name --from-literal=$key --namespace=$ns
echo '        - name: '$dt
echo '          valueFrom:'
echo '            secretKeyRef:'
echo '              name:' $name
echo '              key:' `echo $key`| cut -d'=' -f1
echo '              optional: true'


echo '######################### PLAYBOOK'
echo ''
playbooktag=`echo $key| cut -d'=' -f1`
echo $pt': "${'$playbooktag'}"'

echo '######################### APPLICATION'
echo ''
echo $at'={{'$pt'}}'

fi

if [ $appotion == '11' ] ; then
echo 'grep pattern'
read pattern
echo 'deployments'
kubectl --kubeconfig=$config  get deployments | grep $pattern 

echo 'services'
kubectl --kubeconfig=$config  get services | grep $pattern 
fi

if [ $appotion == '12' ] ; then
mainMenu 
fi

if [ $appotion == '13' ] ; then
appListing 
fi

if [ $appotion == '14' ] ; then
echo 'Good Bye'
exit 
fi


done



