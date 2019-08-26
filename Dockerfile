ARG APP_NAME="webhook"
ARG VERSION="2.6.9"

# --- BUILDER LAYER -------------------------------
FROM golang:alpine3.10 AS build

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
FROM alpine:3.10 AS final

ARG APP_NAME
ARG VERSION

# Install basics
RUN set -eux && apk --update --no-cache add \
    ca-certificates tini

COPY --from=build /go/bin/"${APP_NAME}" /usr/local/bin/"${APP_NAME}"
VOLUME [ "/etc/webhook" ]
EXPOSE 9000
WORKDIR [ "/etc/webhook" ]

# Run as non-root
RUN addgroup -S grp_"${APP_NAME}" && \
    adduser -S usr_"${APP_NAME}" -G grp_"${APP_NAME}" && \
    chown usr_"${APP_NAME}":grp_"${APP_NAME}" /usr/local/bin/"${APP_NAME}"
USER usr_"${APP_NAME}"

ENTRYPOINT  [ "/sbin/tini", "--" ]
CMD [ "/usr/local/bin/webhook", "-version" ]