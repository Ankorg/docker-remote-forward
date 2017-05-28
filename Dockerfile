FROM alpine:latest
MAINTAINER ankur4u007@ank.codes
WORKDIR /home

RUN apk update && \
        apk add wget tar g++ make openssh bash sudo && \
        wget ftp://ftp.gnu.org/pub/gnu/httptunnel/httptunnel-3.3.tar.gz

RUN tar -xf httptunnel-3.3.tar.gz && \
        cd httptunnel-3.3 && ./configure && make && make install && \
	rm -f ../httptunnel-3.3.tar.gz && rm -r ../httptunnel-3.3 && \
        apk del wget tar g++ make && \
        mkdir -p /home/ssh && \
	ssh-keygen -f /home/ssh/ssh_host_rsa_key -N '' -t rsa && \
	ssh-keygen -f /home/ssh/ssh_host_dsa_key -N '' -t dsa && \
	touch /home/ssh/authorized_keys && chmod 655 /home/ssh/authorized_keys && \
        rm -rf /var/cache/apk/*

RUN cp -r /etc/ssh/* ssh/
RUN cp /usr/sbin/sshd ssh/
COPY .docker/sshd_config ssh/
COPY .docker/init.sh .

ENV USER deepankarsingh
ENV PASSWD nonroot@passwd1
RUN adduser -D -s /bin/bash -h /home/$USER -g "User" $USER
RUN echo "$USER:$PASSWD" | chpasswd
RUN chmod -R 777 /home

USER $USER
EXPOSE 8022 8080
ENTRYPOINT /home/init.sh
