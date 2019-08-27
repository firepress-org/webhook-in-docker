ARG APP_NAME="webhook"
ARG VERSION="2.6.9"
ARG GIT_REPO="https://github.com/firepress-org/webhook-in-docker"
ARG ALPINE_VERSION="3.10"

# --- BUILDER LAYER -------------------------------
FROM golang:alpine${ALPINE_VERSION} AS build

ARG APP_NAME
ARG VERSION
# Warning. Because the CI rebuild the image everyday,
# we install the latest version of the app regardless the $VERSION we define in the Dockerfile.

WORKDIR go/src/github.com/adnanh/webhook

# Install basics
RUN set -eux && apk --update --no-cache add \
    bash wget curl git openssl ca-certificates fuse tini upx

# Install Go dependencies
RUN set -eux && apk --update --no-cache add \
    -t build-deps curl libc-dev gcc libgcc

# Install app
RUN go get -u -v github.com/adnanh/"${APP_NAME}" && \
    # compress binary
    upx /go/bin/"${APP_NAME}" && \
    upx -t /go/bin/"${APP_NAME}" && \
    "${APP_NAME}" -version


# --- FINAL LAYER -------------------------------
FROM ubuntu:16.04 AS final

ARG APP_NAME
ARG VERSION
ARG GIT_REPO
ARG ALPINE_VERSION

ENV APP_NAME="${APP_NAME}"
ENV VERSION="${VERSION}"
ENV GIT_REPO="${GIT_REPO}"
ENV ALPINE_VERSION="{ALPINE_VERSION}"
ENV CREATED_DATE="$(date "+%Y-%m-%d_%HH%Ms%S")"
ENV SOURCE_COMMIT="$(git rev-parse --short HEAD)"

# Best practice credit: https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title="${APP_NAME}"                                              \
      org.opencontainers.image.version="${VERSION}"                                             \
      org.opencontainers.image.description="See README.md"                                      \
      org.opencontainers.image.authors="Pascal Andy https://firepress.org/en/contact/"          \
      org.opencontainers.image.created="${CREATED_DATE}"                                        \
      org.opencontainers.image.revision="${SOURCE_COMMIT}"                                      \
      org.opencontainers.image.source="${GIT_REPO}"       \
      org.opencontainers.image.licenses="GNUv3. See README.md" \
      org.firepress.image.user="root"                                                \
      org.firepress.image.alpineversion="{ALPINE_VERSION}"                                      \
      org.firepress.image.field1="not_set"                                                      \
      org.firepress.image.field2="not_set"                                                      \
      org.firepress.image.schemaversion="1.0"

# Install basics
RUN apt-get update -qy && apt-get upgrade -qy && \
    apt-get install ca-certificates tini

#RUN set -eux && apk --update --no-cache add \
#    ca-certificates tini

COPY --from=build /go/bin/"${APP_NAME}" /usr/local/bin/"${APP_NAME}"

WORKDIR /etc/webhook
WORKDIR /mnt/DeployGRP/tooldata/webhooks/
VOLUME [ "/etc/webhook", "/mnt/DeployGRP/tooldata/webhooks/" ]

EXPOSE 9000
ENTRYPOINT  [ "/sbin/tini", "--" ]
CMD [ "/usr/local/bin/webhook", "-version" ]