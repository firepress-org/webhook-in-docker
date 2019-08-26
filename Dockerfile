# --- BUILDER LAYER -------------------------------
FROM golang:alpine3.10 AS build
ARG APP_NAME="webhook"
ARG VERSION="2.6.9"

WORKDIR go/src/github.com/adnanh/webhook

# Install basics
RUN set -eux && apk --update --no-cache add \
    bash wget curl git openssl ca-certificates fuse tini upx

# Install Go dependencies
RUN set -eux && apk --update --no-cache add \
    -t build-deps curl libc-dev gcc libgcc

# Build app
RUN curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${VERSION}.tar.gz
RUN tar -xzf webhook.tar.gz --strip 1
RUN go get -d
RUN go build -o /usr/local/bin/webhook
RUN upx /usr/local/bin/webhook && \
    upx -t /usr/local/bin/webhook

# --- FINAL LAYER -------------------------------
FROM alpine:3.10 AS final

COPY --from=build /usr/local/bin/webhook /usr/local/bin/webhook
VOLUME [ "/etc/webhook" ]
EXPOSE 9000
ENTRYPOINT [ "/usr/local/bin/webhook" ]
