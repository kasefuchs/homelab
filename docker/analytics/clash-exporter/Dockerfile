FROM zzde/clash-exporter:latest AS source

FROM alpine:latest

COPY --from=source /app/clash-exporter /usr/bin/clash-exporter

ENTRYPOINT ["/usr/bin/clash-exporter"]
