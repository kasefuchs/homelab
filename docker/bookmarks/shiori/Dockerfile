FROM ghcr.io/go-shiori/shiori:latest AS source

FROM alpine:latest

COPY --from=source /usr/bin/shiori /usr/bin/shiori

ENTRYPOINT ["/usr/bin/shiori", "server"]
