CarrierWave.configure do |config|


  # For testing, upload files to local `tmp` folder.

  if Rails.env.production?
    config.fog_provider = 'fog/aws' 
    config.fog_credentials = {
      # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_ASSET_URL=http://assets.example.com/ S3_BUCKET_NAME=s3_bucket/folder
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :region                => 'eu-central-1'
    }

    config.fog_directory    = ENV['S3_BUCKET_NAME']
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end



end
