require 'sinatra'
require 'base64'

get '/' do
  send_file 'index.html'
end

get '/image/:name' do |name|
  image = File.join('snapshots', "#{name}.jpg")
  send_file image
end

post '/image' do
  image = Base64::decode64(params[:img])
  file_name = File.join('snapshots', "#{Time.now.to_i}.jpg")

  File.open(file_name, 'w') {|f| f.write image }

  image_url = url("/image/#{file_name}")
  "http://mustachify.me/?src=#{image_url}"
end
