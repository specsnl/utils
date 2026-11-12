# syntax=docker/dockerfile:1
# check=error=true

# Latest version of svu image: https://hub.docker.com/r/caarlos0/svu/tags or https://github.com/caarlos0/svu/releases
FROM caarlos0/svu:3.4.4 AS svu

# Latest version of yq: https://hub.docker.com/r/mikefarah/yq/tags
FROM mikefarah/yq:4.54.1 AS yq

# Latest version of Alpine image: https://hub.docker.com/_/alpine/tags
FROM alpine:3.24.3

# Task repository: https://taskfile.dev/docs/installation#cloudsmith
ADD --checksum=sha256:ba20fb60492ecf172fb968f2f9078cb14552dc57609980cb747b5003e80612fd \
    https://dl.cloudsmith.io/public/task/task/rsa.4CC31F6ECC3EC01F.key \
    /etc/apk/keys/task@task-4CC31F6ECC3EC01F.rsa.pub

RUN echo "@task https://dl.cloudsmith.io/public/task/task/alpine/v$(cut -d. -f1,2 /etc/alpine-release)/main" >> /etc/apk/repositories \
    && apk add --no-cache --upgrade --no-progress \
        'ca-certificates>=20260909' \
        bash~=5.3 \
        curl~=8.23 \
        wget~=1.25 \
        jq~=1.8 \
        sed~=4.9 \
        pcre-tools~=8.45 \
        openssh-keygen~=10.3 \
        pass~=1.7 \
        gnupg~=2.4 \
        git~=2.54 \
        sops=~3.12 \
        age~=1.3 \
        openssl~=3.5 \
        wireguard-tools-wg~=1.0 \
        github-cli~=2.97 \
        task@task~=3.54 \
    && apk add --no-cache --upgrade --no-progress --virtual .usermod \
        shadow~=4.18 \
    && usermod --shell /bin/bash root \
    && for i in $(seq 500 1999); do echo "user:x:$i:$i::/home:/sbin/nologin"; done >> /etc/passwd \
    && apk del .usermod

COPY --from=svu /usr/bin/svu /usr/bin/svu
COPY --from=yq /usr/bin/yq /usr/local/bin/yq

WORKDIR /workspace

CMD ["/bin/bash"]
