FROM ubuntu

RUN apt-get update

RUN apt-get install -y ssh iputils-ping wget

COPY .docker/init.sh .

EXPOSE 22 8080

ENTRYPOINT ./init.sh
