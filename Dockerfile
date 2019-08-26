ARG APP_NAME="webhook"
ARG VERSION="2.6.9"

# --- BUILDER LAYER -------------------------------
FROM golang:alpine3.10 AS build

ARG APP_NAME
ARG VERSION

WORKDIR go/src/github.com/adnanh/webhook

# Install basics
RUN set -eux && apk --update --no-cache add \
    bash wget curl git openssl ca-certificates fuse tini upx

# Install Go dependencies
RUN set -eux && apk --update --no-cache add \
    -t build-deps curl libc-dev gcc libgcc

# Install app
# Warning. Because the CI rebuild the image everyday, we install the latest version of the app regardless the $VERSION we define in the Dockerfile.
RUN go get -u -v github.com/adnanh/"${APP_NAME}" && \
    # compress binary
    upx /go/bin/"${APP_NAME}" && \
    upx -t /go/bin/"${APP_NAME}" && \
    "${APP_NAME}" -version


# --- FINAL LAYER -------------------------------
FROM alpine:3.10 AS final

ARG APP_NAME
ARG VERSION

# Install basics
RUN set -eux && apk --update --no-cache add \
    openssl ca-certificates tini

COPY --from=build /go/bin/"${APP_NAME}" /usr/local/bin/"${APP_NAME}"
VOLUME [ "/etc/webhook" ]
EXPOSE 9000
WORKDIR /etc/webhook
ENTRYPOINT [ "/usr/local/bin/webhook" ]
