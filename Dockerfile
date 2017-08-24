FROM docker.io/library/alpine:3.6
MAINTAINER ankur4u007@ank.codes
WORKDIR /home
ENV MUSL_NSCD_VERSION=1.0.1
COPY .docker/nss_wrapper nss_wrapper
COPY .docker/httptunnel httptunnel
ENV USER nonrootuser
ENV PASSWD nonroot@passwd1

RUN adduser -u 1001 -D -s /bin/bash -h $PWD/$USER -G root $USER && \
	echo "$USER:$PASSWD" | chpasswd && \
	chmod -R g+w $PWD && chown -R $USER $PWD && \
	apk update && \
        apk add openssh bash tini musl-utils cmake cmocka-dev wget tar g++ autoconf automake make \
	&& wget https://github.com/pikhq/musl-nscd/archive/v$MUSL_NSCD_VERSION.tar.gz \
	&& tar -xf v$MUSL_NSCD_VERSION.tar.gz \
        && (cd musl-nscd-$MUSL_NSCD_VERSION \
        && sed 's/exit 1 ;//' -i configure \
        && ./configure \
        && make \
        && make install ) \
	&& rm -fr musl-nscd-$MUSL_NSCD_VERSION \
	&& rm -f v$MUSL_NSCD_VERSION.tar.gz \
	&& mkdir nss_wrapper/build && \
	(cd nss_wrapper/build && \
	cmake .. -DUNIT_TESTING:BOOL=ON && \
	make && \
	make CTEST_OUTPUT_ON_FAILURE=TRUE test && \
	make install) && \
	rm -rf nss_wrapper && \
	mkdir -p /$PWD/ssh && \
	cp -r /etc/ssh/* ssh/ && \
	cp /usr/sbin/sshd ssh/ && \
	cd httptunnel && aclocal && autoheader && autoconf && automake --add-missing && \
        ./configure --prefix=/home --enable-debug && make && make install && \
	rm -r ../httptunnel && \
	ssh-keygen -f /home/ssh/ssh_host_rsa_key -N '' -t rsa && \
	ssh-keygen -f /home/ssh/ssh_host_dsa_key -N '' -t dsa && \
	touch /home/ssh/authorized_keys && \
	apk del musl-utils cmake cmocka-dev wget tar g++ autoconf automake make && \
	rm -rf /var/cache/apk/*

COPY .docker/sshd_config ssh/
COPY .docker/init.sh .
COPY .docker/startServices.sh .
RUN chmod -R g+rw $PWD && chown -R $USER $PWD
USER $USER

EXPOSE 8022 8080 9022
ENTRYPOINT ["/home/init.sh"]
CMD ["/home/startServices.sh"]
