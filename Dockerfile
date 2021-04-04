FROM ubuntu:20.04

WORKDIR /webawk

RUN apt update -y && \
    apt install -y gawk jq

COPY . /webawk

CMD [ "./webawk.sh", "-f", "example/simple.awk" ]
