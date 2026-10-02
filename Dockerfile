FROM alpine:3.24.2

# Install dependencies
# tzdata for time syncing
# bash for entrypoint script
# Check https://pkgs.alpinelinux.org/packages for package versions
RUN apk update && apk add --no-cache bash tzdata openssh rsync=3.5.0-r0 \
    # Generate hash for default rsync configuration, used in entrypoint script
    && md5sum /etc/rsyncd.conf > /etc/rsyncd.conf.md5

# Create entrypoint script
ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh && mkdir -p /docker-entrypoint.d

COPY /rsyncd.template.conf /

# Default environment variables
ENV TZ="Europe/Helsinki" \
    LANG="C.UTF-8"

EXPOSE 22
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# RUN rsync in no daemon and expose errors to stdout
CMD [ "/usr/bin/rsync", "--no-detach", "--daemon", "--log-file=/dev/stdout" ]
