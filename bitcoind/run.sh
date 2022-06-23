#!/bin/sh

set -ex

cd /tmp
wget -qO bitcoin.tar.gz "${BITCOIN_URL}"
echo "${BITCOIN_SHA256} bitcoin.tar.gz" | sha256sum -c

mkdir bin
tar -xzvf bitcoin.tar.gz -C /tmp/bin --strip-components=2 "bitcoin-${BITCOIN_VERSION}/bin/bitcoin-cli" "bitcoin-${BITCOIN_VERSION}/bin/bitcoind"
