# Up1-docker
Dockerfile for [Up1](https://github.com/Upload/Up1), a client-side encrypted file hosting service

# How to use Up1-docker
Configuration parameters need to be passed as environment variables to `docker run`, or if you prefer you could edit the Dockerfile and rebuild the container.

TL;DR:
```
docker build -t up1 .
docker run -e "API_KEY=something_random" -e "DELETE_KEY=something_else_random" --name up1 -p 9000:9000 -v /path/to/local/storage/:/srv/Up1/i/ up1
```

All the possible env. vars are specified in the Dockerfile, they're self explainatory.
HTTPS is not supported (there's no way to specify what certs to use) because I keep my containers behind a reverse proxy for HTTPS.
