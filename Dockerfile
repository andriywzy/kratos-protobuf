FROM golang:1.14.10 as build
ADD https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protobuf-all-3.13.0.tar.gz .
WORKDIR /go/protobuf-3.13.0
RUN apt update && \
    apt install file -y && \
    ./configure --prefix=/usr/local/protobuf && \
    make && \
    make install

FROM golang:1.14.10
COPY --from=build /usr/local/protobuf /usr/local/protobuf
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/protobuf/lib/ \
    LIBRARY_PATH=$LIBRARY_PATH:/usr/local/protobuf/lib/ \
    PATH=$PATH:/usr/local/protobuf/bin/ \
    C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/local/protobuf/include/ \
    CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/usr/local/protobuf/include/ \
    PKG_CONFIG_PATH=/usr/local/protobuf/lib/pkgconfig/ \
    GO111MODULE=on
RUN go get -u github.com/go-kratos/kratos/tool/kratos
