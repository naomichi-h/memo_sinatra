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

  # メモのIDを元に、該当するハッシュを取り出す
  def search_hash_by_id(id)
    files = Dir.glob('data/*')
    @memos = files.map { |file| JSON.parse(File.read(file)) }
    @memo = @memos.find { |x| x['id'].include?(id) }
  end

  # 新規メモをJSONファイルとして新規保存する
  def create_memo(title, content, time)
    memo = { 'id' => SecureRandom.uuid, 'title' => title, 'content' => content, 'time' => time }
    File.open("data/memos_#{memo['id']}.json", 'w') do |file|
      JSON.dump(memo, file)
    end
  end

  # 編集済メモをJSONファイルに上書き保存する
  def edit_memo(id, title, content, time)
    memo = { 'id' => id, 'title' => title, 'content' => content, 'time' => time }
    File.open("data/memos_#{@id}.json", 'w') do |file|
      JSON.dump(memo, file)
    end
  end
end

not_found do
  @title = '404エラー | memo sinatra'
  erb :error404
end

get '/memos' do
  @title = 'メモ一覧 | memo sinatra'
<<<<<<< HEAD
  # 取得したメモを時間順に並び替える
  @memos = Memo.find_memo_all
=======
  files = Dir.glob('data/*')
  # JSONファイルを全て読み込み、ハッシュの配列にする
  @memos = files.map { |file| JSON.parse(File.read(file)) }
  @memos.sort_by! { |h| h['time'] }
>>>>>>> main
  erb :memos
end

get '/memos/:id' do
  @title = 'メモ詳細 | memo sinatra'
<<<<<<< HEAD
  @id = params[:id]
  @memo = Memo.find_memo(@id)
=======
  # メモのID
  @id = params[:id]

  search_hash_by_id(@id)

>>>>>>> main
  @memo ? (erb :memo_detail) : (redirect not_found)
end

get '/memo' do
  @title = 'メモ作成 | memo sinatra'
  erb :memo_create
end

get '/memos/:id/edit' do
  @title = 'メモ編集 | memo sinatra'
<<<<<<< HEAD
  @id = params[:id]
  @memo = Memo.find_memo(@id)
  @memo ? (erb :memo_edit) : (redirect not_found)
end

=======
  # メモのID
  @id = params[:id]

  search_hash_with_id(@id)

  @memo ? (erb :memo_edit) : (redirect not_found)
end

>>>>>>> main
post '/memos' do
  @id = SecureRandom.uuid
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')

<<<<<<< HEAD
  Memo.create_memo(@id, @title, @content, @time)
=======
  create_memo(@title, @content, @time)

>>>>>>> main
  redirect to('/memos')
end

delete '/memos/:id' do
  @id = params[:id]
<<<<<<< HEAD
  Memo.delete_memo(@id)
=======
  File.delete("data/memos_#{@id}.json")
>>>>>>> main
  redirect to('/memos')
end

patch '/memos/:id' do
  @id = params[:id]
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')
<<<<<<< HEAD
  Memo.update_memo(@title, @content, @time, @id)
=======
  edit_memo(@id, @title, @content, @time)
>>>>>>> main
  redirect to("/memos/#{@id}")
end
