#!/bin/sh

set -ex

#if [ "${TARGETARCH}" = "arm64" ]; then
#    BITCOIN_URL="https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-aarch64-linux-gnu.tar.gz"
#    BITCOIN_SHA256="${SHA256_ARM64}"
#else
#    BITCOIN_URL="https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz"
#    BITCOIN_SHA256="${SHA256_AMD64}"
#fi

cd /tmp
wget -qO bitcoin.tar.gz "${BITCOIN_URL}"
echo "${BITCOIN_SHA256} bitcoin.tar.gz" | sha256sum -c

mkdir bin
tar -xzvf bitcoin.tar.gz -C /tmp/bin --strip-components=2 "bitcoin-${BITCOIN_VERSION}/bin/bitcoin-cli" "bitcoin-${BITCOIN_VERSION}/bin/bitcoind"
