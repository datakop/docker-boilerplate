#
# This image contains pre-installed Hello World Django Project.
#
FROM boilerplate
MAINTAINER Boris Kopin kopbob@gmail.com

# Install psql dev lib
RUN apt-get update
RUN apt-get install -y postgresql-server-dev-9.3 postgresql-client-9.3 openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config



# Install Node.js
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc


RUN npm install -g bower less


EXPOSE 22


CMD env | grep _ >> /etc/environment && /usr/sbin/sshd -D