class Queue
  include Enumerable

  def initialize(file)
    @file = file
  end

  def entries
    File.read(@file).split("\n").map { |e| e.to_s }
  end

  def each
    entries.each { |e| yield e }
  end
end

queue = Queue.new('./' + __FILE__)
puts queue.map { |x| "line: #{x}" }
