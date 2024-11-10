FROM serjs/go-socks5-proxy:latest AS source

FROM alpine:latest

COPY --from=source /socks5 /usr/bin/socks5

ENTRYPOINT ["/usr/bin/socks5"]
