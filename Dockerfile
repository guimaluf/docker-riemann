FROM openjdk:8-alpine
LABEL maintainer="Guilherme Maluf <guimalufb@gmail.com>"

ARG RIEMANN_VERSION=0.3.1
ARG RIEMANN_PKG_URL=https://github.com/riemann/riemann/releases/download/$RIEMANN_VERSION/riemann-$RIEMANN_VERSION.tar.bz2

WORKDIR /usr/local
RUN apk add --no-cache openssl \
 && wget ${RIEMANN_PKG_URL} -O- | tar xj \
 && ln -s riemann-$RIEMANN_VERSION riemann

WORKDIR /usr/local/riemann
RUN sed -ie 's/env bash/env sh/' bin/riemann

EXPOSE 5555/tcp 5555/udp 5556

ENTRYPOINT ["bin/riemann"]
CMD ["etc/riemann.config"]
