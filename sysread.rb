aFile = File.new('sysread.rb')
if aFile
  puts aFile.sysread(30)
else
  puts 'Unable to open file!'
end
