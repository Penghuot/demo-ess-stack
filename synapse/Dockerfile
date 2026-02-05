FROM matrixdotorg/synapse:v1.146.0

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy config template
COPY homeserver.template.yaml /data/homeserver.template.yaml

# Create necessary directories
RUN mkdir -p /data/media_store

EXPOSE 8008

ENTRYPOINT ["/entrypoint.sh"]
