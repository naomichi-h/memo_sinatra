require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

get '/index' do
  files = Dir.glob("data/*")
  #JSON->ハッシュ->配列
  @memos = files.map {|file| JSON.load(File.read(file))}
  erb :index
end

get '/memo' do
  erb :memo
end



post '/memo' do
  @title = params[:title]
  @content = params[:content]

  memo = { "id" => SecureRandom.uuid, "title" => @title, "content"=> @content }
  File.open("data/memos_#{memo["id"]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to("index")
end