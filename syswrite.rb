aFile = File.new('testfile', 'r+')

if aFile
  aFile.syswrite(('a'..'z').to_a.join)
else
  puts 'Unable to write file!'
end

aFile.sysseek(0)#, IO::SEEK_SET)
puts aFile.read
