#!/bin/bash -e

#echo "edit me !!!!" ; exit 1

mybase="docker.high-con.de/debian-mini-amd64:9.8"

# add Segger J-Link Software
[[ -e software/JLink_Linux_V644d_x86_64.deb ]]
[[ -e software/nRF-Command-Line-Tools_9_8_1_Linux-x86_64.tar ]]
[[ -e software/zephyr-sdk-0.10.0-setup.run ]] || ( cd software && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.0/zephyr-sdk-0.10.0-setup.run )
    
echo "FROM $mybase" > Dockerfile
echo "MAINTAINER \"Gerd Pauli <gp@high-consulting.de>\"" >> Dockerfile
echo "COPY software/JLink_Linux_V644d_x86_64.deb /root" >> Dockerfile
echo "ENV LC_ALL=C" >> Dockerfile 
echo "ENV LANGUAGE=C" >> Dockerfile
echo "ENV LANG=C" >> Dockerfile
echo "ENV TERM=dumb" >> Dockerfile
echo "RUN apt-get update" >> Dockerfile
echo "RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils" >> Dockerfile
echo "RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libncurses5" >> Dockerfile
echo "RUN dpkg -i /root/JLink_Linux_V644d_x86_64.deb" >> Dockerfile
echo "RUN rm -f /root/JLink_Linux_V644d_x86_64.deb" >> Dockerfile
echo "COPY software/nRF-Command-Line-Tools_9_8_1_Linux-x86_64.tar /root" >> Dockerfile
echo "RUN tar -C /usr/local -xf /root/nRF-Command-Line-Tools_9_8_1_Linux-x86_64.tar" >> Dockerfile
echo "RUN cd /usr/local/bin && ln -s ../nrfjprog/nrfjprog" >> Dockerfile
echo "RUN cd /usr/local/bin && ln -s ../mergehex/mergehex" >> Dockerfile
echo "RUN rm -f /root/nRF-Command-Line-Tools_9_8_1_Linux-x86_64.tar" >> Dockerfile
echo "ENV JLINK_VERSION=V6.44d" >> Dockerfile
echo "ENV NRF_COMMAND_VERSION=9.8.1" >> Dockerfile 
echo "RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget python3-pip python3-setuptools python3-wheel xz-utils file make gcc gcc-multilib lbzip2" >> Dockerfile
echo "RUN pip3 install --user cmake" >> Dockerfile
echo "COPY software/zephyr-sdk-0.10.0-setup.run /root" >> Dockerfile
echo "RUN cd /root && sh zephyr-sdk-0.10.0-setup.run" >> Dockerfile
echo "RUN rm -f /root/zephyr-sdk-0.10.0-setup.run" >> Dockerfile
echo "ENV ZEPHYR_SDK_VSERION=0.10.0" >> Dockerfile 

docker build -t makeit_debootstrap .

#docker tag makeit_debootstrap $mytag 
#docker rmi makeit_debootstrap


