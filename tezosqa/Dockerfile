FROM python:3.8-slim-bullseye

ARG SMARTPY_VERSION
ARG SMARTPY_PATH

ENV SMARTPY_INSTALL_URL https://smartpy.io/releases/${SMARTPY_VERSION}/cli

RUN smartpy_version_year=$(echo $SMARTPY_VERSION | cut -c 1-4) \
    && echo "Install system dependencies for python and pip" \
    && pip install -U pip \
    && echo "Done base install!" \
    && echo "Install basics Python tools" \
    && pip install pipenv \
    && echo "Done!" \
    && echo "Install crypto libs" \
    && apt-get update -q -y && apt-get install -q -y libsodium-dev libsecp256k1-dev libgmp-dev gcc git g++ make \
    && echo "Done!" \
    && echo "Install SmartPyDev" \
    && apt-get install -q -y curl \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    && curl -s "${SMARTPY_INSTALL_URL}/install.sh" | bash /dev/stdin --prefix ${SMARTPY_PATH} --from ${SMARTPY_INSTALL_URL} --yes \
    && echo "export PATH=${SMARTPY_PATH}:\$PATH" >> /etc/profile \
    && echo "Done!" \
    && echo "Install ligo" \
    && curl https://ligolang.org/bin/linux/ligo -o ./ligo \
    && chmod +x ./ligo && mv ./ligo /usr/local/bin \
    && echo "Done!" \
    && echo "Install Pytezos" \
    && apt-get install -q -y pkg-config \
    && pip install pytezos pytest ipython fire pysodium secp256k1 'fastecdsa<2.0.0' \
    && echo "Done!" \
    && echo "Cleanup" \
    && apt-get -q -y autoremove \
    && apt-get -q -y clean && apt-get -q -y purge \
    && rm -rf /var/lib/apt/lists/* /var/lib/dpkg/*-old \
    && echo "Done!"
