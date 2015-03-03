p ARGV

# get -c option's value
p ARGV.include?('-c') && ARGV[ARGV.index('-c') + 1]
