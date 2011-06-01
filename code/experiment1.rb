require 'experiments'

datasets = {
  d1: 'u1',
  d2: 'u2',
  d3: 'u3',
  d4: 'u4',
  d5: 'u5'
}

results = {}
datasets.each do |name,path|
  o = {
    dataset: '/movielens/movielens-100k/base/100/' + path + '.base',
    testset: '/movielens/movielens-100k/test/' + path + '.test'
  }
  rs = AR.recommenders(o)
  ev = AR.evaluate(rs,o)
  ev.each do |name, e|
    results[name] = {} unless results.key?(name)
    results[name][path] = e.round(5)
  end
end

mins  = {}
maxs  = {}
means = {}
devs  = {}

AR::Log.head('Results')

results.each do |method, res|
  print "#{method.to_s.ljust(15)}\t"
  res.each do |set, e|
    print "  #{set}: #{e}\t"
  end
  v = res.values
  print "min: #{v.min}\t"
  print "max: #{v.max}\t"
  print "avg: #{v.mean}\t"
  print "stddev: #{v.stddev.round(6)}"
  puts

  mins[method] = v.min
  maxs[method] = v.max
  means[method] = v.mean
  devs[method] = v.stddev.round(6)
end

puts

puts "avgs:"
pp means.sort { |a,b| a.last <=> b.last }
puts


