# Rails環境

## 仕様
Dockerfile Gemfile Gemfile.lock README.md docker-compose.yml mysql_confが初期ファイルとディレクトリ

## 使い方

docker-compose.ymlとDockerfireのproduct_nameは適宜作るプロダクトネームに書き換えてください。

後はコマンドを順に打っていってください。

`
$ bundle install --path /vendor/bundle
`

`
$ bundle exec rails new product_name
`

`
$ docker-compose build
`

`
$ docker-compose up
`

localhost:3000でアクセスしてRailsの画面が出てきたら完了です。
