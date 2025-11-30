FROM alpine:3.22.2

# Install dependencies
# tzdata for time syncing
# bash for entrypoint script
# openrc to start SSH server daemon
# Check https://pkgs.alpinelinux.org/packages for package versions
RUN apk update && apk add --no-cache bash tzdata openssh rsync=3.4.1-r1 openrc \
    # Generate hash for default rsync configuration, used in entrypoint script
    && md5sum /etc/rsyncd.conf > /etc/rsyncd.conf.md5 \
    # Setup and start SSH
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel \
    && rc-update add sshd

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
