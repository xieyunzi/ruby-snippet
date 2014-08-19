begin
  file = File.open 'ok'
  if file
    puts 'File open successfully'
  end
rescue
  file = STDIN
end

puts file.inspect, '='*70, STDIN.inspect
