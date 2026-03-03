FROM golang:1.19
COPY docker-gs-ping /docker-gs-ping
CMD ["/docker-gs-ping"]