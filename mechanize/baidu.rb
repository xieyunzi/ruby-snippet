require 'mechanize'
require 'byebug'

a = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.follow_meta_refresh = true
end

a.get('http://baidu.com/') do |page|
  search_result = page.form_with(id: 'form', action: '/s') do |search|
    search.wd = 'hello world'
  end.submit

  search_result.links.each do |link|
    puts link.text
  end
end
