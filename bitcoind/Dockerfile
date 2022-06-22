# Image inspired from https://github.com/btcpayserver/dockerfile-deps/blob/master/Bitcoin/0.19.0.1/linuxamd64.Dockerfile
FROM debian:buster-slim as builder
ARG BITCOIN_VERSION


FROM builder as builder-amd64
ARG SHA256_AMD64
ARG BITCOIN_SHA256=$SHA256_AMD64
ARG BITCOIN_URL="https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz"

FROM builder as builder-arm64
ARG SHA256_ARM64
ARG BITCOIN_SHA256=$SHA256_ARM64
ARG BITCOIN_URL="https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-aarch64-linux-gnu.tar.gz"

FROM builder-$TARGETARCH as builderTarget
RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr wget
COPY run.sh .
RUN ./run.sh

FROM debian:buster-slim
COPY --from=builderTarget "/tmp/bin" /usr/local/bin

EXPOSE 8332 8333 18332 18333 18443 18444
CMD ["bitcoind"]
