# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

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
  files = Dir.glob('data/*')
  # JSONファイルを全て読み込み、ハッシュの配列にする
  @memos = files.map { |file| JSON.parse(File.read(file)) }
  @memos.sort_by! { |h| h['time'] }
  erb :memos
end

get '/memos/:id' do
  @title = 'メモ詳細 | memo sinatra'
  # メモのID
  @id = params[:id]

  search_hash_by_id(@id)

  @memo ? (erb :memo_detail) : (redirect not_found)
end

get '/memo' do
  @title = 'メモ作成 | memo sinatra'
  erb :memo_create
end

get '/memos/:id/edit' do
  @title = 'メモ編集 | memo sinatra'
  # メモのID
  @id = params[:id]

  search_hash_with_id(@id)

  @memo ? (erb :memo_edit) : (redirect not_found)
end

post '/memos' do
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')

  create_memo(@title, @content, @time)

  redirect to('/memos')
end

delete '/memos/:id' do
  @id = params[:id]
  File.delete("data/memos_#{@id}.json")
  redirect to('/memos')
end

patch '/memos/:id' do
  @id = params[:id]
  @title = params[:title]
  @content = params[:content]
  @time = Time.now.strftime('%Y年%m月%d日 %a %H:%M')
  edit_memo(@id, @title, @content, @time)
  redirect to("/memos/#{@id}")
end
