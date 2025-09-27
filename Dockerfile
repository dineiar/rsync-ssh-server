FROM alpine:3.22.1

# Install dependencies
# tzdata for time syncing
# bash for entrypoint script
# openrc to start SSH server daemon
RUN apk update && apk add --no-cache bash tzdata openssh rsync openrc \
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
