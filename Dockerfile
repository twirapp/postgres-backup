FROM alpine:edge

RUN apk update
RUN apk add \
	coreutils \
	postgresql17-client \
	python3 \
    py3-pip \
	openssl \
    wget

RUN pip3 install --upgrade pip --break-system-packages && pip3 install awscli --break-system-packages

RUN wget -q -t3 'https://packages.doppler.com/public/cli/rsa.8004D9FF50437357.key' -O /etc/apk/keys/cli@doppler-8004D9FF50437357.rsa.pub && \
  echo 'https://packages.doppler.com/public/cli/alpine/any-version/main' | tee -a /etc/apk/repositories && \
  apk add doppler && apk del wget && \
  rm -rf /var/cache/apk/*

RUN rm -rf /var/cache/apk/*

WORKDIR /app

COPY . .
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["sh", "run.sh"]
