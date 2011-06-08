require 'experiments'

# Chose which disjoint subsets of movielens to run the experiment on.
# Five subsets (u1 to u5) are available.
datasets = {
  #d1: 'u1',
  #d2: 'u2',
  #d3: 'u3',
  #d4: 'u4',
  d5: 'u5'
}

# Run all recommenders on each dataset and store the results.
results = {}
datasets.each do |name,path|
  # Set the correct paths for this subset of the data
  o = {
    dataset: '/movielens/movielens-100k/base/100/' + path + '.base',
    testset: '/movielens/movielens-100k/test/' + path + '.test'
  }
  # Create the recommenders
  rs = AR.recommenders(o)
  # Evaluate across all combinations and store the results
  ev = AR.evaluate(rs,o)
  ev.each do |name, e|
    results[name] = {} unless results.key?(name)
    results[name][path] = e.round(5)
  end
end

# Print out the final results of the experiment
AR::Log.head('Results')
means = {}
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
  means[method] = v.mean
end
puts
puts "avgs:"
pp means.sort { |a,b| a.last <=> b.last }
puts


