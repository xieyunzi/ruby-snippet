puts '='*60, Process.getsid, Process.pid

fork do
  puts '='*60, Process.setsid, Process.pid
end

Process.wait
