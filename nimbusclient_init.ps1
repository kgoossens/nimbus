######################################
# Uncomment what you want to execute
# You should have an account on dockerhub that is linked to the ADM Presales Organisation : https://hub.docker.com/r/admpresales
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

## ALM
#docker run -d -p 8082:8080 -p 1521:1521 --name alm --hostname alm.aos.com --net demo-net --shm-size=2g admpresales/alm:12.55_di

## PC Server
docker create -p 80:80 --name pcserver -t admpresales/pcserver:12.55_oracle

## PC Host on Windows (Ports open to act as: Controller, Data Processor _and_ LG)
docker create -p 8731:8731 -p 54345:54345 -p 54245:54245 --name pchost --hostname pchost -t admpresales/pchost:12.55
