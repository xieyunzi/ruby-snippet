b = 5

haha = case
      when b > 3
        4
      when b > 5
        7
      when b > 10
        11
      end

puts haha


(1..10).each do |i|
  if i > b
    break puts i
  end
end
