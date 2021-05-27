require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  files = Dir.glob("data/*")
  #JSON->ハッシュ->配列
  @memos = files.map {|file| JSON.load(File.read(file))}
  erb :memos_css
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

get '/memo' do
  erb :memo_create
end

get '/memos/:id/edit' do
    #メモのID
    @id = params[:id]
    #メモのIDを元に、該当するハッシュを取り出す
    files = Dir.glob("data/*")
    @memos = files.map {|file| JSON.load(File.read(file))}
    @memo = @memos.find {|x| x["id"].include?(@id)}
    erb :memo_edit
end


post '/memos' do
  @title = params[:title]
  @content = params[:content]

  memo = { "id" => SecureRandom.uuid, "title" => @title, "content"=> @content }
  File.open("data/memos_#{memo["id"]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to("memos")
end

delete '/memos/:id' do
  @id = params[:id]
  File.delete("data/memos_#{@id}.json")
  redirect to ("/memos")
end

patch '/memos/:id' do
  @id = params[:id]
  @title = params[:title]
  @content = params[:content]
  memo = { "id" => @id, "title" => @title, "content"=> @content }
  File.open("data/memos_#{@id}.json", 'w') do |file|
  JSON.dump(memo, file)
end
  redirect to ("/memos/#{@id}")
end