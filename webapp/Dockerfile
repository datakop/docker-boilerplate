#
# This image contains pre-installed Hello World Django Project.
#
FROM boilerplate
MAINTAINER Boris Kopin kopbob@gmail.com

# Install psql dev lib
RUN apt-get update
RUN apt-get install -y postgresql-server-dev-9.3 postgresql-client-9.3


# Copy code
ADD . /home/docker/code/


# Install app requirements
RUN pip install -r /home/docker/code/app/requirements.txt


# setup all the configfiles
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

RUN django-admin.py startproject website /home/docker/code/app/ 

EXPOSE 80

# # CMD ["supervisord", "-c", "/etc/supervisor/supervisor-app.conf"]
CMD ["supervisord", "-n"]
