FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
    libjpeg-dev libwebp-dev golang
RUN git clone https://github.com/discord/lilliput.git
WORKDIR /lilliput/examples
RUN CC=afl-clang CXX=afl-clang++ go build
RUN mkdir /lilliputCorpus
RUN wget https://download.samplelib.com/jpeg/sample-clouds-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-red-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-200x200.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-100x75.jpg
RUN mv *.jpg /lilliputCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/lilliputCorpus", "-o", "/lilliputOut"]
CMD ["/lilliput/examples/examples", "-input", "@@"]
