# Build status-go in a Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ARG build_tags
ARG build_flags

ENV TAG 'v0.16.1'

RUN mkdir -p /go/src/github.com/status-im/status-go && \
    git clone -b $TAG https://github.com/status-im/status-go.git /go/src/github.com/status-im/status-go
RUN cd /go/src/github.com/status-im/status-go && \
    # Hack to allow terminal request to my.status.public.dappnode.eth
    sed -i 's/localhost/*/g' node/node.go && \
    make statusgo \
    BUILD_TAGS="$build_tags" \
    BUILD_FLAGS="$build_flags"

# Copy the binary to the second image
FROM alpine:latest

LABEL maintainer="support@status.im"
LABEL source="https://github.com/status-im/status-go"
LABEL description="status-go is an underlying part of Status - a browser, messenger, and gateway to a decentralized world."

RUN apk add --no-cache ca-certificates bash
RUN mkdir -p /static/keys

COPY --from=builder /go/src/github.com/status-im/status-go/build/bin/statusd /usr/local/bin/
COPY --from=builder /go/src/github.com/status-im/status-go/static/keys/* /static/keys/

# 30304 is used for Discovery v5
EXPOSE 30303 30303/udp 30304/udp

COPY config.json /data/config.json
COPY configMailServer.json /data/configMailServer.json
COPY entrypoint.sh entrypoint.sh

ENV STATUSD_MODE RELAY

ENTRYPOINT ["/entrypoint.sh"]