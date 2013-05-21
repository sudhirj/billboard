class Signs
  def call(env)
    request = Rack::Request.new(env)
    key = remove_starting_slash request.path
    return not_found unless image_at(key).exists?
    type = request.params["t"]

    headers = {
      "Content-Type" => "image/#{type}",
      "Cache-Control" => "public, max-age=2592000",
      "Content-Disposition" => "inline"
    }
    image = image_at(key)
    width = request.params["w"]

    image_content = width ? resize(image, width) : image.read

    [200, headers, [image_content]]
  end

  private
    def resize(image, width)
      tempfile = Tempfile.new(SecureRandom.hex)
      tempfile.binmode
      tempfile.write(image.read)
      tempfile.close
      Magick::Image.read(tempfile.open).first.change_geometry!(width){|cols, rows, img| img.resize! cols, rows}.to_blob
    end

    def remove_starting_slash path
      path.sub('/', '')
    end

    def image_at key
      bucket.objects[key]
    end

    def not_found
      [404, {"Content-Type" => 'text/plain'}, ["Not Found"]]
    end

    def config
      YAML.load File.read 'config.yml'
    end

    def bucket
      bucket_name = ENV['BUCKET'] || config["bucket"]
      s3.buckets[bucket_name]
    end

    def s3
      @s3 ||= AWS::S3.new({
                            :access_key_id => ENV['ACCESS_KEY_ID'] || config["access_key_id"],
                            :secret_access_key => ENV['SECRET_ACCESS_KEY'] || config["secret_access_key"]
      })
    end
end
