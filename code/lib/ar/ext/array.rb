class Array

  def sum
    inject(:+).to_f
  end

  def mean
    sum / size.to_f
  end
  
  def min
    sort.first
  end

  def max
    sort.last
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
