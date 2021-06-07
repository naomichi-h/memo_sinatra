# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'pg'

class Memo
  class << self
    def prepare_db
      @conn = PG.connect(dbname: 'memo_sinatra')
      @conn.prepare('find', 'SELECT * FROM Memos WHERE id = $1;')
      @conn.prepare('create', 'INSERT INTO Memos (id, title, content, time) VALUES ($1, $2, $3, $4);')
      @conn.prepare('delete', 'DELETE FROM memos WHERE id = $1;')
      @conn.prepare('update', 'UPDATE memos SET title = $1, content = $2, time = $3 WHERE id = $4;')
    end

    # メモ全件取得
    def find_memo_all
      @conn.exec('SELECT * FROM Memos ORDER BY time DESC;')
    end

    # 　idに該当するメモを一件取得
    def find_memo(id)
      @conn.exec_prepared('find', [id])
    end

    # 新規メモ登録
    def create_memo(id, title, content, time)
      @conn.exec_prepared('create', [id, title, content, time])
    end

    # メモ削除
    def delete_memo(id)
      @conn.exec_prepared('delete', [id])
    end

    # メモ更新
    def update_memo(title, content, time, id)
      @conn.exec_prepared('update', [title, content, time, id])
    end
  end
end

before do
  Memo.prepare_db
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

not_found do
  @title = '404エラー | memo sinatra'
  erb :error404
end

get '/memos' do
  @title = 'メモ一覧 | memo sinatra'
  # 取得したメモを時間順に並び替える
  @memos = Memo.find_memo_all
  erb :memos
end

get '/memos/:id' do
  @title = 'メモ詳細 | memo sinatra'
  @id = params[:id]
  @memo = Memo.find_memo(@id)
  @memo ? (erb :memo_detail) : (redirect not_found)
end

get '/memo' do
  @title = 'メモ作成 | memo sinatra'
  erb :memo_create
end

get '/memos/:id/edit' do
  @title = 'メモ編集 | memo sinatra'
  @id = params[:id]
  @memo = Memo.find_memo(@id)
  @memo ? (erb :memo_edit) : (redirect not_found)
end

post '/memos' do
  @id = SecureRandom.uuid
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')

  Memo.create_memo(@id, @title, @content, @time)
  redirect to('/memos')
end

delete '/memos/:id' do
  @id = params[:id]
  Memo.delete_memo(@id)
  redirect to('/memos')
end

patch '/memos/:id' do
  @id = params[:id]
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')
  Memo.update_memo(@title, @content, @time, @id)
  redirect to("/memos/#{@id}")
end
