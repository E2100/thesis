require 'lib/metamodel'
M  = MetaModel

module MetaModel
  extend self

  def recommender_tasks(opts = {})
    {
      svd1:       Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 10}.merge(opts)),
      svd2:       Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 20}.merge(opts)),
      svd3:       Task.new({recommender: :svd, factorizer: :em, factorizer_features: 10}.merge(opts)),
      svd4:       Task.new({recommender: :svd, factorizer: :em, factorizer_features: 20}.merge(opts)),
      knn1:       Task.new({recommender: :generic_user}.merge(opts)),
      #knn2:       Task.new({recommender: :generic_user, user_similarity: :spearman}.merge(opts)),
      #knn3:       Task.new({recommender: :generic_user, user_similarity: :log}.merge(opts)),
      #knn4:       Task.new({recommender: :generic_user, user_similarity: :cosine}.merge(opts)),
      slope_one:  Task.new({recommender: :slope_one}.merge(opts)),
      baseline:   Task.new({recommender: :item_user_average}.merge(opts)),
      cosine:     Task.new({recommender: :generic_item}.merge(opts)) 
    }
  end
  
  def meta_tasks(recs, opts = {})
    {
      m_average: Task.new({recommender: :meta_basic, meta_method: :average, recommenders: recs.clone}.merge(opts)),
      m_median:  Task.new({recommender: :meta_basic, meta_method: :median,  recommenders: recs.clone}.merge(opts)),
    }
  end

  def svd_task(recs, opts = {})
    Task.new({
      recommender: :meta_svd,
      recommenders: recs.clone 
    }.merge(opts))
  end

  def evaluate(recommenders, opts = {})
    result = Perform.perform(Task.new({
      mission: :rmse_evaluator,
      recommenders: recommenders,
    }.merge(opts))).evaluate
    Log.evaluation(result)
    result
  end

  def recommenders(opts = {})
    rs  = Perform.perform_all(M.recommender_tasks(opts))
    ms  = Perform.perform_all(M.meta_tasks(rs, opts)) 
    svd = Perform.perform(M.svd_task(rs, opts))
    rs.merge!(ms)
    rs[:m_svd] = svd
    rs
  end
end


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
  rs = M.recommenders(o)
  ev = M.evaluate(rs,o)
  ev.each do |name, e|
    results[name] = {} unless results.key?(name)
    results[name][path] = e.round(5)
  end
end

mins  = {}
maxs  = {}
means = {}
devs  = {}

M::Log.head('Results')

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


