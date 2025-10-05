FROM debian:latest

LABEL maintainer="Marc Sune <marcdevel@gmail.com>"
LABEL version="latest"
LABEL description="bitpuff.io MTU setup test"
LABEL org.opencontainers.image.authors="Marc Sune <marcdevel@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/bitpuff-io/code/"
LABEL org.opencontainers.image.documentation="https://bitpuff.io/tutorials/setup/"
LABEL org.opencontainers.image.source="https://github.com/bitpuff-io/code/"
LABEL org.opencontainers.image.licenses="BSD"

RUN apt update && apt install -y --no-install-recommends \
	iproute2       \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /bp
COPY . /bp
WORKDIR /root
CMD ["/bp/entrypoint.sh"]
