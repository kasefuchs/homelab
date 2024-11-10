FROM vikunja/vikunja:latest AS source

FROM alpine:latest

WORKDIR /app/vikunja

ENV VIKUNJA_SERVICE_ROOTPATH=/app/vikunja/

COPY --from=source /app/vikunja/vikunja .

ENTRYPOINT ["/app/vikunja/vikunja"]
