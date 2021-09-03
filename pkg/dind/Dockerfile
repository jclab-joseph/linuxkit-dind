FROM docker:20.10.6-dind

ADD ["linuxkit-entrypoint.sh", "/"]
RUN chmod +x /linuxkit-entrypoint.sh

ENTRYPOINT []
CMD [ "/linuxkit-entrypoint.sh", "/usr/local/bin/dockerd-entrypoint.sh" ]

