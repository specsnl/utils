# syntax=docker/dockerfile:1
# check=error=true

# Latest version of age: https://github.com/FiloSottile/age/releases
ARG AGE_VERSION=1.3.2

# Latest version of svu image: https://hub.docker.com/r/caarlos0/svu/tags or https://github.com/caarlos0/svu/releases
FROM caarlos0/svu:3.4.1 AS svu

# Latest version of sops image: https://github.com/getsops/sops/pkgs/container/sops or https://github.com/getsops/sops/releases
FROM ghcr.io/getsops/sops:v3.13.3-alpine AS sops

FROM scratch AS age-amd64
ARG AGE_VERSION
ADD --unpack=true --checksum=sha256:cbe24006683f8eb669266162894b9a522a1af52f2665fbc63a4bb032ed26ac10 \
    https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz /

FROM scratch AS age-arm64
ARG AGE_VERSION
ADD --unpack=true --checksum=sha256:6b8dc4333c53a5a57c9e5834e3a48f92605d7154014cd07269ff3327db5d37f4 \
    https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-arm64.tar.gz /

# hadolint ignore=DL3006
FROM age-${TARGETARCH} AS age

# Latest version of Alpine image: https://hub.docker.com/_/alpine/tags
FROM alpine:3.24.2

RUN apk add --no-cache --upgrade --no-progress \
        bash~=5.3 \
        curl~=8.22 \
        wget~=1.25 \
        jq~=1.8 \
        yq~=4.53 \
        sed~=4.9 \
        pcre-tools~=8.45 \
        openssh-keygen~=10.3 \
        pass~=1.7 \
        gnupg~=2.4 \
        git~=2.54 \
    && apk add --no-cache --upgrade --no-progress --virtual .usermod \
        shadow~=4.18 \
    && usermod --shell /bin/bash root \
    && for i in $(seq 500 1999); do echo "user:x:$i:$i::/home:/sbin/nologin"; done >> /etc/passwd \
    && apk del .usermod

COPY --from=svu /usr/bin/svu /usr/bin/svu
COPY --from=sops /usr/local/bin/sops /usr/local/bin/sops
COPY --from=age --chown=root:root /age/age /age/age-keygen /usr/local/bin/

WORKDIR /workspace

CMD ["/bin/bash"]
