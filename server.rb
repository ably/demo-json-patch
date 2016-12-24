require 'webrick'

server = WEBrick::HTTPServer.new :Port => ENV['PORT'] || 8000

server.mount_proc '/' do |req, res|
  if !ENV['ABLY_API_KEY']
    res.status = 500
    res.body = "ABLY_API_KEY is missing. If this is running in Heroku, have you added the Ably addon? See https://devcenter.heroku.com/articles/ably"
  else
    res.body = File.read(File.join(File.dirname(__FILE__), 'index.html')).
      gsub('[INSERT_API_KEY_HERE]', ENV['ABLY_API_KEY'])
  end
end

server.start
