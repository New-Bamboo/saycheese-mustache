require 'sinatra'
require 'sinatra-websocket'
require 'aws/s3'
require 'base64'

AWS::S3::Base.establish_connection!(
  :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
)

class ImageStore < AWS::S3::S3Object
  set_current_bucket_to ENV['S3_BUCKET_NAME']

  def store(name, image)
    super name, image, :access => :public_read
  end
end

get '/' do
  send_file 'index.html'
end

get '/image/:name' do |name|
  image = File.join('snapshots', "#{name}.jpg")
  send_file image
end

post '/image' do
  image = Base64::decode64(params[:img])
  name  = "#{Time.now.to_i}.png"

  ImageStore.store name, image
  image_url = ImageStore.find(name).url
  "http://mustachify.me/?src=#{image_url}"
end
