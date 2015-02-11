require 'spidr'

Spidr.site('http://www.rubyflow.com/') do |spider|
  #spider.every_link { |url| puts url }
  spider.every_page do |page|
    puts '='*70, page.body.inspect, page.code, '='*70
=begin
    page.each_redirect do |location|
      Spidr.site(location) do |spider|
        spider.every_link do |link|
          puts link
        end
      end
    end
=end
  end

end
