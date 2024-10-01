FROM --platform=linux/x86_64 node:20

RUN apt-get update && apt-get install wget -y
RUN apt-get install -y openssh-server

# Add a line in the /etc/hosts

RUN npm install -g @angular/cli
RUN npm install -g nodemon

RUN mkdir -p /tmp/app

RUN mkdir /var/run/sshd
RUN echo 'root:root123' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]