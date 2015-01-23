20.times do |i|
  print ("="*i).ljust(20) + "#{i}%\r"
  $stdout.flush
  sleep 1
end
