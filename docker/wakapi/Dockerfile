FROM golang:latest AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -v -o /wakapi main.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=build /wakapi /wakapi

ENTRYPOINT ["/wakapi"]
