FROM nginx:latest
MAINTAINER Edwin Donderwinkel

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg

ADD http://repo.z-hub.io/z-push:/final/Debian_9.0/Release.key /tmp/z-push-release-key

RUN apt-key add /tmp/z-push-release-key && \
	rm /tmp/z-push-release-key && \
	echo "deb http://repo.z-hub.io/z-push:/final/Debian_9.0/ /" >> /etc/apt/sources.list.d/z-push.list 

ADD start-z-push.sh /usr/local/bin/start-z-push.sh

RUN mkdir -p /var/log/z-push/ && \
	chmod -R 770 /var/log/z-push/ && \
	chown -R www-data:www-data /var/log/z-push/

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	php-mbstring \
	php-curl \
	php-fpm \
	z-push-common \
	z-push-backend-imap \
	z-push-backend-carddav \
	z-push-backend-caldav \
	z-push-backend-combined \
	z-push-ipc-sharedmemory && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* && \
	echo "daemon off;" >> /etc/nginx/nginx.conf && \
	chmod +x /usr/local/bin/start-z-push.sh


ADD default.conf /etc/nginx/conf.d/
ADD php-fpm.conf /etc/php/7.0/fpm

CMD "/usr/local/bin/start-z-push.sh"
