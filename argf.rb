ARGF.each do |line|
  puts ARGF.filename, '*'*80 if ARGF.eof?
  puts line
end
