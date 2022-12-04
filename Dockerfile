FROM fuzzers/afl:2.52 as builder

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
    libjpeg-dev libwebp-dev golang

ADD . /lilliput
WORKDIR /lilliput/examples
RUN CC=afl-clang CXX=afl-clang++ go build
RUN wget https://download.samplelib.com/jpeg/sample-clouds-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-red-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-200x200.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-100x75.jpg

FROM fuzzers/afl:2.52
COPY --from=builder /lilliput/examples/examples /
COPY --from=builder /lilliput/examples/*.jpg /testsuite/

ENTRYPOINT ["afl-fuzz", "-i", "/testsuite", "-o", "/lilliputOut"]
CMD ["/examples", "-input", "@@"]
