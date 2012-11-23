class ImageStore < AWS::S3::S3Object
  set_current_bucket_to ENV['S3_BUCKET_NAME']

  def store(name, image)
    super name, image, :access => :public_read
  end
end
