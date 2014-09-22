
# Pull base image.
FROM ubuntu:14.04


##########################################
######                              ######
######      Ubuntu                  ######
######                              ######
##########################################

# Install.
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

# Define working directory.
# WORKDIR /root

# Define default command.
# CMD ["bash"]



##########################################
######                              ######
######      nginx                   ######
######                              ######
##########################################

# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
# VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

# Define working directory.
# WORKDIR /etc/nginx

# Define default command.
# CMD ["nginx"]

# Expose ports.
# EXPOSE 80
# EXPOSE 443


##########################################
######                              ######
######      Supervisor              ######
######                              ######
##########################################

# Install Supervisor.
RUN \
  apt-get update && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# Define mountable directories.
# VOLUME ["/etc/supervisor/conf.d"]

# Define working directory.
WORKDIR /etc/supervisor/conf.d

# Define default command.
# CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]



##########################################
######                              ######
######      PSQL                    ######
######                              ######
##########################################

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r postgres && useradd -r -g postgres postgres

# grab gosu for easy step-down from root
RUN apt-get update && apt-get install -y curl wget && rm -rf /var/lib/apt/lists/* \
    && curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
    && chmod +x /usr/local/bin/gosu \
    && apt-get purge -y --auto-remove curl

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# RUN apt-key adv --keyserver pgp.mit.edu --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

ENV PG_MAJOR 9.3
ENV PG_VERSION 9.3.5-1.pgdg70+1

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update \
    && apt-get install -y postgresql-common \
    && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
    && apt-get install -y \
        postgresql-$PG_MAJOR=$PG_VERSION \
        postgresql-contrib-$PG_MAJOR=$PG_VERSION \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
# VOLUME /var/lib/postgresql/data

COPY psql9.3/docker-entrypoint.sh /

# ENTRYPOINT ["/docker-entrypoint.sh"]

# EXPOSE 5432
# CMD ["postgres"]





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

# Define working directory.
# WORKDIR /data

# Define default command.
# CMD ["bash"]



##########################################
######                              ######
######      Base                    ######
######                              ######
##########################################

RUN pip install uwsgi

ADD base/ /home/docker/code/

# setup all the configfiles
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

# RUN pip install
RUN pip install -r /home/docker/code/app/requirements.txt

# install django, normally you would remove this step because your project would already
# be installed in the code/app/ directory
RUN django-admin.py startproject website /home/docker/code/app/ 

EXPOSE 80
# CMD ["supervisord", "-c", "/etc/supervisor/supervisor-app.conf"]
CMD ["supervisord", "-n"]
