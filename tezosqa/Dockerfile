FROM docker:20.10.24-dind 

WORKDIR /tezos

RUN echo "Install python3 and pip3" \
    && apk  --no-cache --update add python3 py3-pip\
    && echo "Done!" \
    && echo "Install basics Python tools" \
    && pip3 install -U pipenv \
    && echo "Done!" \
    && echo "Install crypto libs and various tools" \
    && apk add -q libsodium-dev pkgconfig libsecp256k1-dev gmp-dev python3-dev libffi-dev gcc git g++ make wget bash musl-dev linux-headers\
    && echo "Done!" \
    && echo "Install SmartPyDev" \
    && wget https://smartpy.io/smartpy \
    && chmod +x smartpy && mv smartpy /usr/local/bin \
    && echo "Done!" \
    && echo "Install ligo" \
    && wget https://gitlab.com/ligolang/ligo/-/jobs/4260236028/artifacts/raw/ligo \
    && chmod +x ./ligo && mv ligo /usr/bin \
    && echo "Done!" \
    && echo "Install Pytezos and other python libs" \
    && pip install pytezos pytest ipython fire pysodium secp256k1 \
    && echo "Done!" \
    && echo "Cleanup" \
    && rm -rf /var/cache/apk/* && pip cache purge \
    && echo "Done!"
