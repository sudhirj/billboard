
class Signs
  def call(env)
    request = Rack::Request.new(env)
    key = remove_starting_slash request.path
    return not_found unless bucket.objects[key].exists?

    image = image_at(key)
    width = request.params["w"]

    image_content = (width ? resize(image, width) : image).to_blob

    type = (image.inspect.split(' ').compact.map(&:downcase) & ['jpg', 'jpeg', 'png']).first

    headers = {
      "Content-Type" => "image/#{type}",
      "Cache-Control" => "public, max-age=2592000",
      "Content-Disposition" => "inline"
    }

    [200, headers, [image_content]]
  end

  private
    def resize(image, width)
      image.first.change_geometry!(width){|cols, rows, img| img.resize! cols, rows}
    end

    def remove_starting_slash path
      path.sub('/', '')
    end

    def image_at key
      Magick::Image.from_blob(bucket.objects[key].read)
    end

    def not_found
      [404, {"Content-Type" => 'text/plain'}, ["Not Found"]]
    end

    def config
      YAML.load File.read 'config.yml'
    end

    def bucket
      bucket_name = ENV['BUCKET'] || config["BUCKET"]
      s3.buckets[bucket_name]
    end

    def s3
      @s3 ||= AWS::S3.new({
                            :access_key_id => ENV['ACCESS_KEY_ID'] || config["ACCESS_KEY_ID"],
                            :secret_access_key => ENV['SECRET_ACCESS_KEY'] || config["SECRET_ACCESS_KEY"]
      })
    end
end
