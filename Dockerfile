# Latest version of Alpine image: https://hub.docker.com/_/alpine/tags
FROM alpine:3.23.3

RUN apk add --no-cache --upgrade --no-progress \
        bash~=5.3 \
        curl~=8.17 \
        wget~=1.25 \
        jq~=1.8 \
        yq~=4.49 \
        sed~=4.9 \
        pcre-tools~=8.45 \
        openssh-keygen~=10.2 \
        pass~=1.7 \
        gnupg~=2.4 \
    && apk add --no-cache --upgrade --no-progress --virtual .usermod \
        shadow~=4.18 \
    && usermod --shell /bin/bash root \
    && for i in $(seq 500 1999); do echo "user:x:$i:$i::/home:/sbin/nologin"; done >> /etc/passwd \
    && apk del .usermod

CMD ["/bin/bash"]
