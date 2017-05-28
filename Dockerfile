FROM ubuntu
MAINTAINER ankur4u007 

RUN apt-get update
RUN apt-get install -y ssh iputils-ping wget

WORKDIR /app

RUN mkdir /app/ssh
RUN cp -r /etc/ssh/* ssh/
RUN cp /usr/sbin/sshd ssh/
COPY .docker/sshd_config ssh/

ENV USER nonroot
ENV PASSWD nonroot@passwd1
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/$USER --gecos "User" $USER
RUN echo "$USER:$PASSWD" | chpasswd

COPY .docker/init.sh .
RUN chown -R $USER .

USER $USER

EXPOSE 8022 8080

ENTRYPOINT /app/init.sh
