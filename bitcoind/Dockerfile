# Image inspired from https://github.com/btcpayserver/dockerfile-deps/blob/master/Bitcoin/0.19.0.1/linuxamd64.Dockerfile
FROM debian:buster-slim as builder

ARG BITCOIN_VERSION
ARG SHA256_AMD64
ARG SHA256_ARM64
ARG TARGETARCH

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr wget

# install bitcoin binaries
COPY run.sh .
RUN ./run.sh

FROM debian:buster-slim
COPY --from=builder "/tmp/bin" /usr/local/bin

EXPOSE 8332 8333 18332 18333 18443 18444
CMD ["bitcoind"]
