#!/bin/sh

if [ ! -f server.conf ] 
then 
	./genconfig.sh server.conf.template server.conf
	echo "Generated server configuration:"
	cat server.conf
fi

if [ ! -f ../client/config.js ]
then
	./genconfig.sh ../client/config.js.template ../client/config.js
	echo "Generated client configuration:"
	cat ../client/config.js
fi

echo "Starting server now..."
exec node server.js
