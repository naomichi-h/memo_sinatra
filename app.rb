# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
  # DB接続
  def db_connect(query)
    conn = PG.connect( dbname: 'memo_sinatra')
    conn.exec(query)
  end
end

not_found do
  @title = '404エラー | memo sinatra'
  erb :error404
end

get '/memos' do
  @title = 'メモ一覧 | memo sinatra'
  query = "SELECT * FROM Memos;"

  # 取得したメモを時間順に並び替える
  @memos = db_connect(query).sort_by { |h| h['time'] }

  erb :memos
end

get '/memos/:id' do
  @title = 'メモ詳細 | memo sinatra'
  @id = params[:id]
  query = "SELECT * FROM Memos WHERE id = '#{@id}';"

  @memo = db_connect(query)
  @memo ? (erb :memo_detail) : (redirect not_found)
end

get '/memo' do
  @title = 'メモ作成 | memo sinatra'
  erb :memo_create
end

get '/memos/:id/edit' do
  @title = 'メモ編集 | memo sinatra'
  @id = params[:id]
  query = "SELECT * FROM Memos WHERE id = '#{@id}';"

  @memo = db_connect(query)
  @memo ? (erb :memo_edit) : (redirect not_found)
end

post '/memos' do
  @id = SecureRandom.uuid
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')
  query = "INSERT INTO Memos (id, title, content, time) VALUES ('#{@id}', '#{@title}', '#{@content}', '#{@time}');"

  db_connect(query)
  redirect to('/memos')
end

delete '/memos/:id' do
  @id = params[:id]
  query = "DELETE FROM memos WHERE id = '#{@id}';"

  db_connect(query)
  redirect to('/memos')
end

patch '/memos/:id' do
  @id = params[:id]
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')
  query = "update memos set title = '#{@title}', content = '#{@content}', time = '#{@time}' where id = '#{@id}';"

  db_connect(query)
  redirect to("/memos/#{@id}")
end
