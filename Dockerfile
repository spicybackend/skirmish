FROM amberframework/amber:v0.8.0

WORKDIR /app

COPY shard.* /app/
RUN crystal deps

COPY . /app

RUN rm -rf /app/node_modules

CMD amber watch
