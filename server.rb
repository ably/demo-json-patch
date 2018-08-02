require 'webrick'

server = WEBrick::HTTPServer.new :Port => ENV['PORT'] || 8000

server.mount_proc '/' do |req, res|
  if !ENV['ABLY_API_KEY']
    res.status = 500
    res.body = "ABLY_API_KEY is missing. If this is running in Heroku, have you added the Ably addon? See https://devcenter.heroku.com/articles/ably"
  else
    res.body = File.read(File.join(File.dirname(__FILE__), 'index.html')).
      gsub('[INSERT_API_KEY_HERE]', ENV['ABLY_API_KEY'])

    if ENV['DYNO']
      res.body.gsub!('</body>', '<p class="notice">Have you remembed to set up the "json-patch" namespace in your app? <a href="/heroku-start">Find out how.</a></body>')
    end
  end
end

server.mount_proc '/heroku-start' do |req, res|
  res.body = File.read(File.join(File.dirname(__FILE__), 'heroku-start.html'))
end

server.mount_proc '/GitHub-Mark-32px.png' do |req, res|
  res.body = File.read(File.join(File.dirname(__FILE__), '/GitHub-Mark-32px.png'))
end

server.start
