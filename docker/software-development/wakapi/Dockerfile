FROM ghcr.io/muety/wakapi:latest AS source

FROM alpine:latest

WORKDIR /app

COPY --from=source /app/wakapi .

ENTRYPOINT ["/app/wakapi"]
