FROM ubuntu:latest as builder
MAINTAINER Stille <stille@ioiox.com>

WORKDIR /

COPY . /
RUN apt-get update && \
    apt-get -y install wget && \
    /bin/bash -c '/bin/echo -e "1\n\nn\n" | ./status.sh' && \
    cp -rf /web /usr/local/ServerStatus/

FROM nginx:latest
MAINTAINER Stille <stille@ioiox.com>

COPY --from=builder /usr/local/ServerStatus/server /ServerStatus/server/
COPY --from=builder /usr/local/ServerStatus/web /usr/share/nginx/html/

EXPOSE 80 35601

CMD nohup sh -c '/etc/init.d/nginx start && /ServerStatus/server/sergate --config=/ServerStatus/server/config.json --web-dir=/usr/share/nginx/html'