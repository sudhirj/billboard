class PathParser
  def initialize(path)
    @path = path.split('/')[1]
    parts, @type = @path.split('.')
    @id, *@data = parts.split('_')
  end

  def key
  	@path
  end

  def id
    @id
  end

  def type
    @type
  end

  def width
    pull_integer 'w'
  end

  private
    def pull_integer(key)
      v = @data.find{|d| d.start_with? key}
      v && v.sub(key, '').to_i
    end
end
