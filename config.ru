run lambda { |env|
  response = Rack::Response.new
  response.write Process.pid
  response.finish
}
