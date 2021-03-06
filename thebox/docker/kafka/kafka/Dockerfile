ARG IMAGE

# ----- Base image to get QEMU binaries -----
FROM debian:buster
RUN apt-get update && apt-get install -qqy qemu-user-static

# ----- Acutual image base for Kafka with JRE/Debian -----
FROM ${IMAGE}

# ----- Copy over QEMU ----
COPY --from=0 /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static
COPY --from=0 /usr/bin/qemu-arm-static /usr/bin/qemu-arm-static

ARG kafka_version=2.2.1
ARG scala_version=2.12
ARG glibc_version=2.29-r0
ARG vcs_ref=unspecified
ARG build_date=unspecified

LABEL org.label-schema.name="kafka" \
  org.label-schema.description="Apache Kafka" \
  org.label-schema.build-date="${build_date}" \
  org.label-schema.vcs-url="https://github.com/direbearform/kafka-docker" \
  org.label-schema.vcs-ref="${vcs_ref}" \
  org.label-schema.version="${scala_version}_${kafka_version}" \
  org.label-schema.schema-version="1.0" \
  maintainer="wurstmeister"

ENV KAFKA_VERSION=$kafka_version \
  SCALA_VERSION=$scala_version \
  KAFKA_HOME=/opt/kafka \
  GLIBC_VERSION=$glibc_version

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY download-kafka.sh start-kafka.sh create-topics.sh versions.sh /tmp/

# Install Kafka
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    jq \
    net-tools \
    wait-for-it dos2unix \
  && chmod +x /tmp/*.sh \
  && dos2unix /tmp/*.sh \
  && mv /tmp/start-kafka.sh /tmp/create-topics.sh /tmp/versions.sh /usr/bin \
  && sync && /tmp/download-kafka.sh \
  && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
  && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
  && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
  && rm -rf /tmp/*

COPY overrides /opt/overrides

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]