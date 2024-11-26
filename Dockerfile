# Rubyベースイメージの指定
FROM ruby:3.1.2

RUN apt-get update && apt-get install -y vim

# 必要なシステムライブラリをインストール
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl \
  gnupg2 \
  lsb-release \
  apt-transport-https

# Node.js を公式ソースからインストール
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs

# Yarn をインストール (npmを使用せず直接インストール)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn

# アプリケーションディレクトリを作成
WORKDIR /myapp

# Gemfile と Gemfile.lock をコピーし、依存関係をインストール
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --without development test

# Node.jsのパッケージをインストール（yarn.lockがない場合は省略可）
# COPY package.json yarn.lock /myapp/
RUN yarn install

# アプリケーションコードをすべてコピー
COPY . /myapp

# 本番環境用アセットのプリコンパイル
RUN RAILS_ENV=production bundle exec rails assets:precompile

# 不要なキャッシュを削除して軽量化
RUN rm -rf tmp/cache \
  && yarn cache clean \
  && rm -rf /var/lib/apt/lists/*

# サーバーの起動コマンド
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
