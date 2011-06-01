module AR
module Scale
  extend self

  def from_stars(x)
    (x - 1.0) / 4.0
  end

  def to_stars(x)
    (x * 4.0) + 1
  end

  def constrain(x, min=1.0, max=5.0)
    x = min if x < min
    x = max if x > max
    x
  end
 
end
end
