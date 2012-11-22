require 'sinatra'
require 'aws/s3'
require 'base64'


set :bucket, ENV['S3_BUCKET_NAME']
set :s3_key, ENV['AWS_ACCESS_KEY_ID']
set :s3_secret, ENV['AWS_SECRET_ACCESS_KEY']




get '/' do
  send_file 'index.html'
end

get '/image/:name' do |name|
  image = File.join('snapshots', "#{name}.jpg")
  send_file image
end

post '/image' do
  image = Base64::decode64(params[:img])

  AWS::S3::Base.establish_connection!(
    :access_key_id     => settings.s3_key,
    :secret_access_key => settings.s3_secret
  )

  AWS::S3::S3Object.store(name, image, settings.bucket, :access => :public_read)


  image_url = url("/image/#{file_name}")
  "http://mustachify.me/?src=#{image_url}"
end
