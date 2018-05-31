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
#192.168.203.132	octane.aos.com	octane
#192.168.203.132	mc.aos.com	mc
#192.168.203.132	nimbusserver.aos.com
#192.168.203.132	alm.aos.com
#192.168.203.132	ppm.aos.com
#192.168.203.132	devops.aos.com
#192.168.203.132	aosweb.aos.com
#192.168.203.132	aosaccount.aos.com
#192.168.203.132	aosdb.aos.com
#192.168.203.132	autopass.aos.com

##############
## Autopass ##
##############
docker create --hostname autopass.aos.com --ip=172.50.10.10 --name autopass --net demo-net -p 5814:5814 --restart=always admpresales/autopass:9.3.3_d

###############################
## Advantage Online Shopping ##
###############################

# AOS-Postgres Database
docker create -p 5432:5432 --name aos_postgres --hostname aosdb.aos.com --net demo-net admpresales/aos-postgres:1.1.3.1	

# AOS-accountservice
docker create -p 8001:8080 --name aos_accountservice --hostname aosaccount.aos.com -e "POSTGRES_PORT=5432" -e "POSTGRES_IP=aos_postgres" -e "MAIN_PORT=8000" -e "ACCOUNT_PORT=8001" -e 'MAIN_IP=nimbusserver' -e "ACCOUNT_IP=nimbusserver" -e "PGPASSWORD=admin" --net demo-net admpresales/aos-accountservice:1.1.3.1

# AOS-main
docker create -p 8000:8080 --name aos_main --hostname aosweb.aos.com -e "POSTGRES_PORT=5432" -e "POSTGRES_IP=aos_postgres" -e "MAIN_PORT=8000" -e "ACCOUNT_PORT=8001" -e 'MAIN_IP=nimbusserver' -e "ACCOUNT_IP=nimbusserver" -e "PGPASSWORD=admin" --net demo-net admpresales/aos-main-app:1.1.3.1

## Old Version - Remove when you have access to the 3-part AOS ##
#docker pull admpresales/aos:postgres
#docker pull admpresales/aos:tomcat

############
## Devops ##
############
docker create -p 8090:8080 -p 50000:50000 -p 9022:22 --name devops --hostname devops.aos.com --net demo-net admpresales/devops:1.1.3.4

############
## Octane ##
############
docker create -p 1099:1099 -p 8085:8080 -p 9081:9081 -p 9082:9082 --name octane --hostname octane.aos.com --net demo-net -e OCTANE_HOST=nimbusserver.aos.com --shm-size=2g admpresales/octane:12.55.17.164_dis


######################
## UFT Pro (LeanFT) ##
######################
docker create --name leanft -p 5095:5095 -p 5900:5900 -e LFT_LIC_SERVER=localhost -e LFT_LIC_ID=23078 -e VERBOSE=true --net "host" functionaltesting/leanft-chrome:14.03.546

##############
## IntelliJ ##
##############
# This needs to be run within the GUI of the linux environment (GNOME)
##############
docker create --name intellij -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --net "host" -p 8824:8824 -p 5095:5095 admpresales/intellij:1.1.3.5

###################
## Mobile Center ##
###################
docker create --hostname mc.aos.com --name mc --net demo-net -p 8084:8080 --shm-size=2g admpresales/mc:2.60.1_di

#############
## ALM.Net ##
#############
docker create -p 8082:8080 -p 1521:1521 --name alm --hostname alm.aos.com --net demo-net --shm-size=2g admpresales/alm:12.55_di

#########
## PPM ##
#########
docker create --name ppm --shm-size=2g --hostname=ppm.aos.com -p 8087:8080 -p 1098:1099 --net demo-net --add-host nimbusserver.aos.com:172.50.0.1 --ip 172.50.10.20 admpresales/ppm:9.42.0.1_d
