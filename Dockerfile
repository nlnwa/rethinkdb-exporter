FROM golang:1.19 as build

WORKDIR /go/src/app

COPY . .

RUN go mod download
RUN CGO_ENABLED=0 go install -trimpath -ldflags "-s -w"


FROM gcr.io/distroless/base-debian11
MAINTAINER CMogilko <cmogilko@gmail.com>

COPY --from=build /go/bin/prometheus-exporter /sbin/prometheus-exporter

USER nobody
EXPOSE     9055
ENTRYPOINT [ "/sbin/prometheus-exporter" ]
