FROM linuxkit/alpine:0c069d0fd7defddb6e03925fcd4915407db0c9e1 AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    apk-tools \
    busybox \
    ca-certificates \
    musl \
    openssh-client \
    openssh-server \
    tini \
    util-linux \
    wireguard-tools \
    bash \
    python3 \
    jq \
    && true
RUN mv /out/etc/apk/repositories.upstream /out/etc/apk/repositories

COPY yq-2.12.2-py2.py3-none-any.whl /tmp/
RUN apk add python3 && \
    python3 -m ensurepip --default-pip && \
    pip3 install --root /out /tmp/yq-2.12.2-py2.py3-none-any.whl

FROM scratch
ENTRYPOINT []
WORKDIR /
COPY --from=mirror /out/ /
COPY etc/ /etc/
COPY usr/ /usr/
RUN mkdir -p /etc/ssh /root/.ssh && chmod 0700 /root/.ssh
CMD ["/sbin/tini", "/usr/bin/ssh.sh"]
