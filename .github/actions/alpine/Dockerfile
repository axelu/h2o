FROM alpine:edge
RUN apk add --no-cache alpine-sdk lua-aports pigz gcc-gnat perl openssl cmake ruby-dev bison zlib-dev wslay-dev openssl-dev libuv-dev yaml-dev brotli-dev perl-test-harness-utils perl-test-tcp perl-test-simple perl-json perl-path-tiny perl-scope-guard perl-test-exception perl-protocol-http2 perl-test-requires perl-hash-multivalue perl-plack perl-lwp-protocol-https perl-http-headers-fast perl-cookie-baker perl-http-entity-parser perl-starlet perl-fcgi-procmanager perl-cgi perl-fcgi nodejs wget netcat-openbsd
RUN echo "127.0.0.1 127.0.0.1.xip.io" >> /etc/hosts
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

