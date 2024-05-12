# syntax=docker/dockerfile:1
# MAINTAINER "Parker Rowe <parker@prowe.ca>"

FROM alpine:latest

ARG POCKETCMS_VERSION=0.1.4
ARG LITESTREAM_VERSION=v0.3.13

# Install the dependencies
RUN apk add --no-cache \
    ca-certificates \
    unzip \
    wget \
    zip \
    zlib-dev \
    bash

RUN mkdir -p /pb_data

# Download Pocketcms and install it for AMD64
ADD https://github.com/parkuman/pocketcms/releases/download/v${POCKETCMS_VERSION}/pocketcms_${POCKETCMS_VERSION}_linux_amd64.zip /tmp/pocketcms.zip
RUN unzip /tmp/pocketcms.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/pocketcms

# Download the static build of Litestream directly into the path & make it executable.
# This is done in the builder and copied as the chmod doubles the size.
# Note: You will want to mount your own Litestream configuration file at /etc/litestream.yml in the container.
# Example: https://github.com/benbjohnson/litestream-docker-example or https://litestream.io/guides/docker/
ADD https://github.com/benbjohnson/litestream/releases/download/${LITESTREAM_VERSION}/litestream-${LITESTREAM_VERSION}-linux-amd64.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz

# Notify Docker that the container wants to expose a port.
# Pocketcms serve port
# For the litestream server via Prometheus
EXPOSE 8090
# EXPOSE 9090 

# Copy Litestream configuration file & startup script.
COPY etc/litestream.yml /etc/litestream.yml
COPY scripts/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh
RUN chmod +x /usr/local/bin/litestream

# Start Pocketcms
CMD [ "/scripts/run.sh" ]
