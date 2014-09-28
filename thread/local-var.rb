count = 0
thread = []

10.times do |i|
  thread[i] = Thread.new do
    sleep(0.2)

    Thread.current['myvalue'] = count
    count += 1
  end
end

thread.each { |t| t.join; puts t['myvalue'] }
