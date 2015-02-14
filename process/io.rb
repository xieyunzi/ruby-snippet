reader, writer = IO.pipe

#writer.write('Into the pipe I go ...')
#writer.close
#puts reader.read

fork do
  reader.close

  10.times do
    writer.puts 'Another one bites the dust'
  end
end

writer.close
while message = reader.gets
  $stdout.puts message
end
