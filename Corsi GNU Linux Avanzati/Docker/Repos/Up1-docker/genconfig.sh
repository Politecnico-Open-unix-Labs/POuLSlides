#!/bin/sh
cat "$1" | \
sed -r "s/\{\{HTTP\}\}/$HTTP/" | \
sed -r "s/\{\{HTTP_LISTEN\}\}/$HTTP_LISTEN/" | \
sed -r "s/\{\{HTTPS\}\}/$HTTPS/" | \
sed -r "s/\{\{HTTPS_LISTEN\}\}/$HTTPS_LISTEN/" | \
sed -r "s/\{\{API_KEY\}\}/$API_KEY/" | \
sed -r "s/\{\{DELETE_KEY\}\}/$DELETE_KEY/" | \
sed -r "s/\{\{SERVER\}\}/$SERVER/" | \
sed -r "s/\{\{FOOTER\}\}/$FOOTER/" | \
sed -r "s/\{\{MAX_FILE_SIZE\}\}/$MAX_FILE_SIZE/"  > `printf "$2"`

