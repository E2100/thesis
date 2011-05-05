class Array

  def sum
    self.inject(:+).to_f
  end

  def mean
    self.sum / self.size.to_f
  end
  
  def min
    self.sort.first
  end

  def max
    self.sort.last
  end
  
  def variance
    m = mean
    s = 0.0
    each { |x| s += (x-m) ** 2 } 
    s / size
  end

  def stddev
    Math.sqrt(variance)
  end

end

d = [2,3,2,2,3,4,5,5,4,3,4,1,2]

puts d.sum
puts d.variance
puts d.stddev
