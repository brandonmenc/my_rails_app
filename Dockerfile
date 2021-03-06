FROM ruby:2.7.2-buster

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
            libjemalloc2 \
    ; \
    rm -rf /var/lib/apt/lists/*

ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so.2

# Install Node
RUN set -eux; \
    NODE_VERSION="node_12.x"; \
    DISTRO="buster"; \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -; \
    echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list; \
    echo "deb-src https://deb.nodesource.com/$NODE_VERSION $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list; \
    apt-get update; \
    apt-get install -y nodejs; \
    rm -rf /var/lib/apt/lists/*

RUN npm install --quiet -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY yarn.lock package.json ./
RUN yarn install --check-files

COPY . .

ENV BIND_ADDR 0.0.0.0
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
