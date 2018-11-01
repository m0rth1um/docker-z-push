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
	chmod +x start-z-push.sh && \
	sed -i "s/define('BACKEND_PROVIDER', '')/define('BACKEND_PROVIDER', 'BackendCombined')/" ./z-push/config.php && \
	sed -i "s/define('IMAP_FOLDER_CONFIGURED', false)/define('IMAP_FOLDER_CONFIGURED', true)/" ./z-push/backend/imap/config.php && \
	sed -i "s/define('IMAP_FOLDER_PREFIX', '')/define('IMAP_FOLDER_PREFIX', 'INBOX')/" ./z-push/backend/imap/config.php && \
	sed -i "s/define('IMAP_SERVER', 'localhost')/define('IMAP_SERVER', getenv('MAILSERVER_ADDRESS'))/" ./z-push/backend/imap/config.php && \
	sed -i "s/define('IMAP_PORT', 143)/define('IMAP_PORT', getenv('MAILSERVER_PORT'))/" ./z-push/backend/imap/config.php && \
	sed -i "s/define('CALDAV_SERVER', 'caldavserver.domain.com')/define('CALDAV_SERVER', getenv('CALDAV_ADDRESS'))/" ./z-push/backend/caldav/config.php && \
	sed -i "s/define('CALDAV_PORT', '443')/define('CALDAV_PORT', getenv('CALDAV_PORT'))/" ./z-push/backend/caldav/config.php && \
	sed -i "s/define('CALDAV_PATH', '/caldav.php/%u/')/define('CALDAV_PATH', getenv('CALDAV_PATH'))/" ./z-push/backend/caldav/config.php && \
	sed -i "s/define('CALDAV_PROTOCOL', 'https')/define('CALDAV_PROTOCOL', getenv('CALDAV_PROTOCOL'))/" ./z-push/backend/caldav/config.php && \
	sed -i "s/define('CARDDAV_SERVER', 'localhost')/define('CARDDAV_SERVER', getenv('CARDDAV_ADDRESS'))/" ./z-push/backend/carddav/config.php && \
	sed -i "s/define('CARDDAV_PORT', '443')/define('CARDDAV_PORT', getenv('CARDDAV_PORT'))/" ./z-push/backend/carddav/config.php && \
	sed -i "s/define('CARDDAV_PATH', '/caldav.php/%u/')/define('CARDDAV_PATH', getenv('CARDDAV_PATH'))/" ./z-push/backend/carddav/config.php && \
	sed -i "s/define('CARDDAV_PROTOCOL', 'https')/define('CARDDAV_PROTOCOL', getenv('CARDDAV_PROTOCOL'))/" ./z-push/backend/carddav/config.php && \
	sed -i "s/define('CARDDAV_DEFAULT_PATH', '/caldav.php/%u/addresses/')/define('CARDDAV_DEFAULT_PATH', getenv('CARDDAV_PATH'))/" ./z-push/backend/carddav/config.php

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
