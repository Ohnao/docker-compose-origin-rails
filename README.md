# README
## 仕様
Dockerfile Gemfile Gemfile.lock README.md docker-compose.yml mysql_confが初期ファイルとディレクトリ
## 使い方

まず、dockerイメージを作成する

`
$ docker-compose build
`

イメージを作成した後にコンテナ内に入る

`
$ docker-compose run web /bin/bash
`

入ったコンテナ内でrailsアプリを作成する

`
$ bundle exec rails new product_name
`

Dockerfileのset directory and Gemfileの記述部分のADD GemfileとADD Gemfile.lockのパスにproduct_nameの場所を追加する

`
##
### set directory and Gemfile
##
RUN mkdir /app-space
WORKDIR /app-space
ADD Gemfile /app-space/product_name/Gemfile
ADD Gemfile.lock /app-space/product_name/Gemfile.lock
ADD . /app-space
RUN bundle update && bundle install
`

docker-compose upでrailsサーバーを起動する

`
$ docker-compose up
`

localhost:3000にアクセスしてRailsの画面が出たらOK
