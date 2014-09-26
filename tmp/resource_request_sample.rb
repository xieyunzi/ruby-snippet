require 'rubygems'
require 'rack/oauth2'

def url_for(path)
  File.join("http://rack-oauth2-sample.heroku.com", path)
end

resource_of = :user

case resource_of
when :user
  token = Rack::OAuth2::AccessToken::Bearer.new(
    :access_token => 'YOUR_ACCESS_TOKEN_FOR_USER'
  )
  begin
    p token.get url_for('/protected_resources')
    p token.post url_for('/protected_resources'), {}
  rescue => e
    p e.response.headers[:www_authenticate]
  end
when :client
  token = Rack::OAuth2::AccessToken::Bearer.new(
    :access_token => 'YOUR_ACCESS_TOKEN_FOR_CLIENT'
  )
  begin
    p token.get url_for('/client_statistic')
  rescue => e
    p e.response.headers[:www_authenticate]
  end
end
