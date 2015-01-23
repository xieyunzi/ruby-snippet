9.times do |i|
  Thread.start {
    while true
      print "thread #{i}\n"
    end
  }
end

while true
  sleep 9
end
