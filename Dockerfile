# syntax=docker/dockerfile:1
# check=error=true

FROM caarlos0/svu:3.4.1 AS svu

# Latest version of Alpine image: https://hub.docker.com/_/alpine/tags
FROM alpine:3.24.1

RUN apk add --no-cache --upgrade --no-progress \
        bash~=5.3 \
        curl~=8.20 \
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

WORKDIR /workspace

CMD ["/bin/bash"]
