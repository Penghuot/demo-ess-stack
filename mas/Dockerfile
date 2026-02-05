FROM ghcr.io/element-hq/matrix-authentication-service:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY config.template.yaml /data/config.template.yaml

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
