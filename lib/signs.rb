class Signs
	def call(env)
		request = Rack::Request.new(env)
		[200, {"Content-Type" => 'text/plain'}, [request.path]]
	end
end
