FROM golang:1.9 as builder

COPY . /go/src/github.com/camflan/cachet-monitor
WORKDIR /go/src/github.com/camflan/cachet-monitor/cli

RUN go get
RUN CGO_ENABLED=0 go build -a -tags netgo -ldflags '-w' -o ../app .

FROM gcr.io/distroless/base
LABEL maintainer="Camron Flanders <camron.flanders@gmail.com>"

COPY --from=builder /go/src/github.com/camflan/cachet-monitor/app /app

CMD ["/app", "-c /config.json"]
