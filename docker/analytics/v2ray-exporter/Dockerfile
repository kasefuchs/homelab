FROM wi1dcard/v2ray-exporter:master AS source

FROM alpine:latest

COPY --from=source /usr/bin/v2ray-exporter /usr/bin/v2ray-exporter

ENTRYPOINT ["/usr/bin/v2ray-exporter"]
