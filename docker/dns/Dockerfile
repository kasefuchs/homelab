FROM internetsystemsconsortium/bind9:9.21

COPY --from=hairyhenderson/gomplate:v5.3.1 /gomplate /usr/local/bin/

COPY rootfs/ /

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
