FROM dzwicker/docker-ubuntu:latest
MAINTAINER daniel.zwicker@in2experience.com

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN \
    mkdir -p /var/lib/youtrack && \
    groupadd --gid 2000 youtrack && \
    useradd --system -d /var/lib/youtrack --uid 2000 --gid youtrack youtrack && \
    chown -R youtrack:youtrack /var/lib/youtrack

######### Install hub ###################
COPY entry-point.sh /entry-point.sh

RUN \
    export YOUTRACK_VERSION=7.0.27676 && \
    mkdir -p /usr/local/youtrack && \
    mkdir -p /var/lib/youtrack && \
    cd /usr/local && \
    curl -L https://download.jetbrains.com/charisma/youtrack-${YOUTRACK_VERSION}.zip > youtrack.zip && \
    unzip youtrack.zip && \
    rm -f youtrack.zip && \
    mv youtrack-${YOUTRACK_VERSION} youtrack && \
    cd youtrack && \
    echo "$YOUTRACK_VERSION" > version.docker.image && \
    chown -R youtrack:youtrack /usr/local/youtrack

USER youtrack
ENV HOME=/var/lib/youtrack
EXPOSE 8080
ENTRYPOINT ["/entry-point.sh"]
CMD ["run"]
