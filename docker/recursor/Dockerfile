FROM alpine:3.24

COPY --from=coredns/coredns:1.14.4 /coredns /usr/local/bin/
COPY --from=hairyhenderson/gomplate:v5.1.0 /gomplate /usr/local/bin/

COPY rootfs/ /

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
