FROM nginx:alpine
MAINTAINER Thomas VIAL

WORKDIR /usr/share/nginx
ADD start-z-push.sh .

RUN apk update && \
	apk add php5 php5-imap php5-fpm php5-posix php5-pdo && \
	rm -rf /var/cache/apk/* && \
	wget http://download.z-push.org/final/2.3/z-push-2.3.6.tar.gz -O z-push.tar.gz && \
	tar xzf z-push.tar.gz && \
	mv z-push-* z-push && \
	rm z-push.tar.gz && \
	mkdir -p /var/log/z-push/ /var/lib/z-push/ && \
	chmod 770 /var/log/z-push/ /var/lib/z-push/ && \
	chown -R nginx:nobody z-push/ /var/log/z-push/ /var/lib/z-push/ && \
	echo "daemon off;" >> /etc/nginx/nginx.conf && \
	cp -rf /config/* . && \
	chmod +x start-z-push.sh

ADD default.conf /etc/nginx/conf.d/
ADD php-fpm.conf /etc/php5/

ENV MAILSERVER_ADDRESS= 
ENV MAILSERVER_PORT= 

ENV CALDAV_ADDRESS=
ENV CALDAV_PORT=80
ENV CALDAV_PATH='/caldav.php/%u/'
ENV CALDAV_PROTOCOL='https'

ENV CARDDAV_ADDRESS=
ENV CARDDAV_PORT=
ENV CARDDAV_PATH='/carddav.php/%u/' 
ENV CARDDAV_PROTOCOL='https'

CMD "./start-z-push.sh"
