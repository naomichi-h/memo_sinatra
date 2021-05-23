require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

get '/memos' do
  files = Dir.glob("data/*")
  #JSON->ハッシュ->配列
  @memos = files.map {|file| JSON.load(File.read(file))}
  erb :memos
end

get '/memos/:id' do
  #メモのID
  @id = params[:id]
  #メモのIDを元に、該当するハッシュを取り出す
  files = Dir.glob("data/*")
  @memos = files.map {|file| JSON.load(File.read(file))}
  @memo = @memos.find {|x| x["id"].include?(@id)}
  erb :memo_detail
end

get '/memo_create' do
  erb :memo_create
end



post '/memo_create' do
  @title = params[:title]
  @content = params[:content]

  memo = { "id" => SecureRandom.uuid, "title" => @title, "content"=> @content }
  File.open("data/memos_#{memo["id"]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to("memos")
end