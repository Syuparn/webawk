FROM ubuntu:20.04

WORKDIR /webawk

RUN apt update -y && \
    apt install -y gawk jq

COPY . /webawk

ENTRYPOINT [ "./webawk.sh" ]
CMD [ "-f", "example/simple.awk" ]
