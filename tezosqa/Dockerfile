FROM docker:24.0.7-dind

WORKDIR /tezos

RUN echo "Install basics Python tools" \
    apk update && \
    apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools

RUN echo "Install crypto libs and various tools" \
    && apk --no-cache add -q libsodium-dev pkgconfig libsecp256k1-dev gmp-dev python3-dev wget build-base libffi-dev \
    && echo "Done!"

RUN echo "Install SmartPyDev" \
    && wget https://smartpy.io/smartpy \
    && chmod +x smartpy && mv smartpy /usr/local/bin \
    && echo "Done!"

RUN echo "Install ligo" \
    && wget https://gitlab.com/ligolang/ligo/-/jobs/5419828800/artifacts/raw/ligo \
    && chmod +x ./ligo && cp ligo /usr/bin \
    && echo "Done!"

RUN echo "Install Pytezos and other python libs" \
    && pip install pytezos \
    && echo "Done!"

RUN echo "Cleanup" \
    && rm -rf /var/cache/apk/* && pip cache purge \
    && echo "Done!"
