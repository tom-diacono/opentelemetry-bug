 docker build --no-cache -t opentelem-bug .
 docker run -v .:/home/opentelemetry-bug -d --rm -it --name opentelem-bug opentelem-bug
