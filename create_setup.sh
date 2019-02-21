######################################
# Uncomment what you want to execute
# You should have an account on dockerhub that is linked to the ADM Presales Organisation : https://hub.docker.com/r/admpresales
# Latest version available at: https://github.houston.softwaregrp.net/SWLab/NIMBUS
######################################

#########################
## HostFile of your pc ##
#########################
## Remove the "#" before each line and add this to the Host file of your pc in order to be able to access the different servers from your machine.
## Don't forget to update the ipadres below to the address of your NimbusServer external vcard

## Nimbus 2.0
##192.168.217.128	octane.aos.com	octane
##192.168.217.128	mc.aos.com	mc
##192.168.217.128	nimbusserver.aos.com
##192.168.217.128	alm.aos.com
##192.168.217.128	ppm.aos.com
##192.168.217.128	devops.aos.com
##192.168.217.128	aosweb.aos.com
##192.168.217.128	aosaccount.aos.com
##192.168.217.128	aosdb.aos.com
##192.168.217.128	autopass.aos.com

## Nimbus Client
##192.168.217.129 nimbusclient.aos.com

## PC
##192.168.217.130 pc.aos.com
##192.168.217.131 pchost.aos.com

##############
## Autopass ##
##############
docker create --hostname autopass.aos.com --ip=172.50.10.10 --name autopass --net demo-net -p 5814:5814 --restart=always admpresales/autopass:10.7.0_d

###############################
## Advantage Online Shopping ##
###############################

# AOS-Postgres Database
docker create -p 5432:5432 --name aos_postgres --hostname aosdb.aos.com --net demo-net admpresales/aos-postgres:1.1.6

# AOS-accountservice
docker create -p 8001:8080 --name aos_accountservice --hostname aosaccount.aos.com -e "POSTGRES_PORT=5432" -e "POSTGRES_IP=nimbusserver.aos.com" -e "MAIN_PORT=8000" -e "ACCOUNT_PORT=8001" -e 'MAIN_IP=nimbusserver.aos.com' -e "ACCOUNT_IP=nimbusserver.aos.com" -e "PGPASSWORD=admin" -e "AGENT_NAME=aos-accountservice-dev" --add-host nimbusserver.aos.com:172.50.0.1 --net demo-net admpresales/aos-accountservice:1.1.6

# AOS-main
docker create -p 8000:8080 --name aos_main --hostname aosweb.aos.com -e "POSTGRES_PORT=5432" -e "POSTGRES_IP=nimbusserver.aos.com" -e "MAIN_PORT=8000" -e "ACCOUNT_PORT=8001" -e "MAIN_IP=nimbusserver.aos.com" -e "ACCOUNT_IP=nimbusserver.aos.com" -e "PGPASSWORD=admin" -e "AGENT_NAME=aos-main-dev" --add-host nimbusserver:172.50.0.1 --add-host nimbusserver.aos.com:172.50.0.1 --net demo-net admpresales/aos-main-app:1.1.6

## Old Version - Remove when you have access to the 3-part AOS ##
#docker pull admpresales/aos:postgres
#docker pull admpresales/aos:tomcat

############
## Devops ##
############
docker create -p 8090:8080 -p 8091:80 -p 50000:50000 -p 9022:22 --name devops --hostname devops.aos.com --net demo-net --add-host nimbusserver:172.50.0.1 --add-host nimbusserver.aos.com:172.50.0.1 admpresales/devops:1.1.6.1

############
## Octane ##
############
docker create -p 1099:1099 -p 8085:8080 -p 9081:9081 -p 9082:9082 --name octane --hostname octane.aos.com --net demo-net -e OCTANE_HOST=nimbusserver.aos.com --shm-size=2g admpresales/octane:12.60.21.98_dis

######################
## UFT Pro (LeanFT) ##
######################
docker create --name leanft -p 5095:5095 -p 5900:5900 -e LFT_LIC_SERVER=localhost -e LFT_LIC_ID=23078 -e VERBOSE=true --net "host" functionaltesting/leanft-chrome:14.50.836

##############
## IntelliJ ##
##############
# This needs to be run within the GUI of the linux environment (GNOME)
##############
export DISPLAY=:0
docker create --name intellij -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --net "host" -p 8824:8824 -p 5095:5095 admpresales/intellij:1.1.6.0

###################
## Mobile Center ##
###################
docker create --hostname nimbusserver.aos.com --name mc --net demo-net -p 8084:8084 --shm-size=2g admpresales/mc:3.0_di

#############
## ALM.Net ##
#############
docker create -p 8082:8080 -p 1521:1521 --name alm --hostname alm.aos.com --net demo-net --shm-size=2g admpresales/alm:12.60_di

#########
## PPM ##
#########
docker create --name ppm --shm-size=2g --hostname=ppm.aos.com -p 8087:8080 -p 1098:1099 --net demo-net --add-host nimbusserver.aos.com:172.50.0.1 --ip 172.50.10.20 admpresales/ppm:9.50_d

#########
## NV ##
#########

docker create -i --cap-add=NET_ADMIN --name nv --net=host --privileged -v /usr/src:/usr/src admpresales/nv:9.13 /root/dockerentrypointfile.sh

######################
## Android Emulator ##
######################
docker create --rm -e "DEVICE=Nexus7-5.1.1" -e GPU="off" -e "CONSOLE_PORT=5554" -p "5554:5554" -p "5555:5555" -p 6080:6080 -p 8080:8080 --net demo-net --name nexus5 --privileged admpresales/android-emulator:2.70-alpha

###############
## DA-Server ##
###############
docker create -p 8089:8080 -p 7918:7918 --name da --net demo-net admpresales/da-server:6.2.0_di

###############
## SV Server ##
###############
docker create --name sv-svm --net demo-net -p 6086:6086 -h NimbusServer --volumes-from sv-server admpresales/sv-svm:4.20

###################
## Loadgenerator ##
###################

docker create --name lg-001 -p 10001:54345 --hostname=lg-001.aos.com --net demo-net --add-host pc.aos.com:192.168.217.130 performancetesting/load_generator_linux:12.61
docker create --name lg-002 -p 10002:54345 --hostname=lg-002.aos.com --net demo-net --add-host pc.aos.com:192.168.217.130 performancetesting/load_generator_linux:12.61

##############################
## Software Security Center ##
##############################
docker create -e MYSQL_ROOT_PASSWORD=Password1 -e MYSQL_DATABASE=ssc_db --name ssc_db --add-host nimbusserver.aos.com:172.50.0.1 --add-host nimbusserver:172.50.0.1 --net demo-net  admpresales/ssc-mysql:18.10-empty
docker create -e MYSQL_PASS=Password1 --hostname ssc.aos.com --name ssc --net demo-net --add-host nimbusserver.aos.com:172.50.0.1 --add-host nimbusserver:172.50.0.1 -p 8086:8080 admpresales/ssc:18.10

##########################
## Static Code Analyzer ##
##########################
docker create --name sca --net demo-net admpresales/sca:18.20
