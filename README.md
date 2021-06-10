# memo sinatra

「Sinatra でシンプルな Web アプリを作ろう」課題のシンプルなメモアプリです。メモの新規作成、編集、削除が出来ます。

<img width="804" alt="スクリーンショット 2021-05-28 16 34 43" src="https://user-images.githubusercontent.com/73326842/119947353-9d6aed80-bfd2-11eb-8e94-6afd2615f28c.png">

## Requirement

- ruby(3.0.0)
- sinatra(2.1.0)
- sinatra-contrib(2.1.0)
- pg(1.2.3)
- postgres (PostgreSQL) 13.2

## Installation

1. PostgresSQL のデフォルトユーザーで`memo_sinatra`というデータベースを作成し、`CREATE TABLE memos (id VARCHAR(40) NOT NULL, title TEXT, content TEXT, time VARCHAR(40) NOT NULL);`を実行してください。
1. `git clone https://github.com/naomichi-h/memo_sinatra`を実行して任意のディレクトリに複製して下さい。
1. `memo_sinatra`ディレクトリに移動して下さい。
1. `bundle install`を実行して下さい。Gemfile 記載の`sinatra`、`sinatra-contrib`、`pg`および`thin`がインストールされます。
1. `memo_sinatra`ディレクトリで`bundle exec ruby app.rb`を実行してください。
1. 任意のブラウザで`http://localhost:4567/memos`にアクセスしてください。

## Usage

- メモの新規作成
  - メモ一覧ページ上段の「+ メモを新規作成する」をクリックすると、新規メモ作成画面へ移動出来ます。 新規メモ作成画面で、メモのタイトルとメモの内容を書いた後、「保存」ボタンをクリックすると、作成したメモを保存出来ます。
- メモの詳細表示
  - メモの一覧表示画面で、メモのタイトルをクリックすると、メモの詳細画面へ移動出来ます。
- メモの編集
  - メモの詳細画面で、「編集」ボタンをクリックすると、そのメモの編集を行うことが出来ます。 メモのタイトルと内容を編集した後、「保存」ボタンをクリックすると、編集内容を保存出来ます。
- メモの削除
  - メモの詳細画面で、「削除」ボタンをクリックすると、メモを削除することが出来ます。 削除したメモは戻すことが出来ませんので、ご注意ください。
