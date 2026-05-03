FROM alpine:edge

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk update
RUN apk add --no-cache \
    coreutils \
    postgresql18-client \
    python3 \
    py3-pip \
    openssl \
    wget \
    aws-cli

RUN wget -q -t3 'https://packages.doppler.com/public/cli/rsa.8004D9FF50437357.key' -O /etc/apk/keys/cli@doppler-8004D9FF50437357.rsa.pub && \
    echo 'https://packages.doppler.com/public/cli/alpine/any-version/main' | tee -a /etc/apk/repositories && \
    apk add doppler && \
    apk del wget && \
    rm -rf /var/cache/apk/*

WORKDIR /app
COPY . .
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["sh", "run.sh"]
