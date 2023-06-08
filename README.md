## Opentelemetry Bug repo:

This repo is a minimal reproducible example of a bug I found in the opentelemetry php library.

### How to reproduce:

1. Clone this repo
2. Run `sh build.sh`
3. Exec to the container `docker exec -it opentelem-bug /bin/bash`
4. Run `rm -rf var/cache/*`
5. Run `composer install`
6. See segfault
