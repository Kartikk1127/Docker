FROM alpine
RUN apk update && apk add --no-cache cmatrix
ENTRYPOINT ["cmatrix"]
CMD ["-abs","-C","red"]