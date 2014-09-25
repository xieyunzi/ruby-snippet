%w($0 $! $@ $_).each do |var|
  puts "#{var}: " + instance_eval(var).to_s
end
