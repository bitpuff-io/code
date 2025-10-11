FROM debian:latest

LABEL maintainer="Marc Sune <marcdevel@gmail.com>"
LABEL version="latest"
LABEL description="bitpuff.io MTU tutorial docker image"
LABEL org.opencontainers.image.authors="Marc Sune <marcdevel@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/bitpuff-io/code/"
LABEL org.opencontainers.image.documentation="https://bitpuff.io/tutorials/networking/mtu/"
LABEL org.opencontainers.image.source="https://github.com/bitpuff-io/code/"
LABEL org.opencontainers.image.licenses="BSD"

RUN apt update && apt install -y --no-install-recommends \
	curl           \
	iproute2       \
	iputils-ping   \
	make           \
	procps         \
	python3-scapy  \
	tcpdump        \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /bp
COPY . /bp
COPY .bashrc /root/.bashrc
WORKDIR /root
CMD ["/bp/entrypoint.sh"]
