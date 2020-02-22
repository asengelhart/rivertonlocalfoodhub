require 'open-uri'

class Application < Sinatra::Base
  post '/send-newsletter' do
    html_block = params[:newsletter_html]
    filename = "Newsletter"
    File.open(filename, "w") { |f| f.write(html_block) }
    status 200
  end

  get '/last-newsletter' do

  end
end