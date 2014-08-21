def content line
  case line
    when /title=(.*)/
      puts "Title is #$1"
    when /track=(.*)/
      puts "Track is #$1"
    when /artist=(.*)/
      puts "Artist is #$1"
  end
end

content "title=for example, regular expressions define === as a simple pattern match."
