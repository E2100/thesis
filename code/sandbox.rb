require 'pp'

def errors_to_weights(errors)
  weights = {}
  
  # normalize errors
  sorted = errors.sort { |a,b| a.last <=> b.last }
  xmax   = sorted.last.last
  xmin   = sorted.first.last
  ymax   = 1.0
  ymin   = 0.0
  sorted.map! do |x| 
    [x.first, normalize(x.last,xmin,xmax,ymin,ymax)]
  end  

  # turn errors to weights
  sorted.each do |method, error|
    weights[method] = 1.0 - error
  end

  # normalize weights
  sum = weights.values.inject(:+)
  weights.each do |method, weight|
    weights[method] = weight == 0.0 ? 0.0 : weight / sum 
  end
  weights
end

def normalize(x,xmin,xmax,ymin,ymax)
  xrange = xmax-xmin
  yrange = ymax-ymin
  ymin + (x-xmin) * (yrange.to_f / xrange) 
end


r = errors_to_weights({
  emax: 3.0,
  b: 2.0,
  emid: 1.0,
  d: 0.5,
  emin: 0.0
})
pp r

pp r.values.inject(:+)
