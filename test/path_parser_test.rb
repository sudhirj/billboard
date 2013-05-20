require 'path_parser'
require 'minitest/spec'
require 'minitest/autorun'

describe PathParser do
	it "should parse paths to extract image id" do
		PathParser.new('/abc.png').id.must_equal "abc"
		PathParser.new('/abc.png').type.must_equal "png"
		PathParser.new('/23k-dk3l0-wkdk3.jpg').id.must_equal "23k-dk3l0-wkdk3"
		PathParser.new('/23kdk3lwkdk3.jpg').type.must_equal "jpg"
		PathParser.new('/23kdk3lwkdk3.jpg').width.must_be_nil
	end

	it 'should provide a key' do
		PathParser.new('/abc.png').key.must_equal "abc.png"
		PathParser.new('/23k-dk3l0-wkdk3.jpg').key.must_equal "23k-dk3l0-wkdk3.jpg"
	end

	it "should pull out width from the path" do
		PathParser.new('/abc_w234.png').id.must_equal "abc"
		PathParser.new('/abc_w234.png').type.must_equal "png"
		PathParser.new('/abc_w234.png').width.must_equal 234
	end

end