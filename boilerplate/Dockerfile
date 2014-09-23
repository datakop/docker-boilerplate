#
# This image contains pre-installed Ubuntu nginx supervisor Python uwsgi.
#
FROM ubuntu:14.04

MAINTAINER Boris Kopin kopbob@gmail.com


##########################################
######                              ######
######      LANG                    ######
######                              ######
##########################################

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -qy install language-pack-en

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive locale-gen en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN update-locale LANG=en_US.UTF-8

##########################################################################################



##########################################
######                              ######
######      Ubuntu                  ######
######                              ######
##########################################

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD dockers/ubuntu/root/.bashrc /root/.bashrc
ADD dockers/ubuntu/root/.gitconfig /root/.gitconfig
ADD dockers/ubuntu/root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

##########################################################################################



##########################################
######                              ######
######      nginx                   ######
######                              ######
##########################################

RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# # Define mountable directories.
# VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

##########################################################################################



##########################################
######                              ######
######      supervisor              ######
######                              ######
##########################################

RUN \
  apt-get update && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# # Define mountable directories.
# VOLUME ["/etc/supervisor/conf.d"]

##########################################################################################



##########################################
######                              ######
######      Python                  ######
######                              ######
##########################################

# Install Python.
RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*

##########################################################################################



##########################################
######                              ######
######      uwsgi                   ######
######                              ######
##########################################

RUN pip install uwsgi

##########################################################################################
