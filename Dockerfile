FROM openjdk:8-alpine
LABEL maintainer="Guilherme Maluf <guimalufb@gmail.com>"

ARG RIEMANN_VERSION=0.3.1
ARG RIEMANN_PKG_URL=https://github.com/riemann/riemann/releases/download/$RIEMANN_VERSION/riemann-$RIEMANN_VERSION.tar.bz2

RUN apk add --no-cache openssl \
 && wget ${RIEMANN_PKG_URL} -O- | tar xj -C /usr/local/ \
 && ln -s /usr/local/riemann-$RIEMANN_VERSION /usr/local/riemann

WORKDIR /usr/local/riemann
RUN sed -ie 's|env bash|env sh|' bin/riemann \
  && sed -ie 's|riemann.log|/dev/stdout|' etc/riemann.config

ARG RABBITMQ_PLUGIN_URL=https://github.com/avishai-ish-shalom/riemann-rabbitmq-plugin/releases/download/0.1.0/riemann-rabbitmq-plugin-0.1.0-SNAPSHOT-standalone.jar
ADD ${RABBITMQ_PLUGIN_URL} lib/
ENV EXTRA_CLASSPATH=/usr/local/riemann/lib/riemann-rabbitmq-input.jar

EXPOSE 5555/tcp 5555/udp 5556

ENTRYPOINT ["bin/riemann"]
CMD ["etc/riemann.config"]
