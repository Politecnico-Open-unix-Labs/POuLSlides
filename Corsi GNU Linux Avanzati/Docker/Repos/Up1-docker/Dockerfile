FROM node:latest
MAINTAINER fcremo@users.github.com

EXPOSE 9000:9000

ENV HTTP="true" \
	HTTP_LISTEN="0.0.0.0:9000" \
	HTTPS="false" \
	HTTPS_LISTEN=":443" \
	API_KEY="something_really_random" \
	DELETE_KEY="another_random_string" \
	MAX_FILE_SIZE=50000000 \
	SERVER="" \
	FOOTER=""

RUN apt-get install -y git && \
	cd /srv && \
	git clone https://github.com/Upload/Up1 && \
	cd Up1/server && npm install && \
	apt-get remove -y git

WORKDIR /srv/Up1/server

COPY server.conf.template server.conf.template
COPY config.js.template ../client/config.js.template
COPY genconfig.sh genconfig.sh
COPY entrypoint.sh entrypoint.sh

RUN chmod +x genconfig.sh entrypoint.sh

ENTRYPOINT /srv/Up1/server/entrypoint.sh
