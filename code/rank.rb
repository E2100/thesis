require 'pp'
require 'lib/metamodel'
M = MetaModel

def make_recommenders
  M::Perform.perform_all({
    #svd1: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 1}),
    #svd10: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 1}),
    slope_one: M::Task.new({recommender: :slope_one}),
    item_average: M::Task.new({recommender: :item_average}),
    average: M::Task.new({recommender: :item_user_average}),
    generic_user: M::Task.new({recommender: :generic_user}),
    generic_item: M::Task.new({recommender: :generic_item}) 
  })
end

def make_meta_recommender(recommenders)
  n = recommenders.size
  M::Perform.perform(M::Task.new({
    recommender: :meta,
    recommenders: recommenders.clone,
    nn_in: n,
    nn_out: 1,
    nn_hidden: [n+1],
    nn_transfer: :sigmoid,
    nn_learning_rate: 0.3,
    nn_max_iterations: 100,
    nn_max_error: 0.001,
    nn_momentum: 0.0  
  }))
end

def ir(query, n=10)
  M::Lucene::API.new.query(query,n)
end

def predictions(recommenders,user,item)
  {}.tap do |res|
    recommenders.each do |name,rec|
      begin
        p = rec.prediction(user,item)
        next if p.nan?
        res[name] = p
      rescue M::PredictionError
        res[name] = -1.0
      end
    end
  end
end

query = 'war'
user  = 1
recommenders = make_recommenders
recommenders[:meta] = make_meta_recommender(recommenders)

ir(query).each_with_index do |r,i|
  doc = r.last
  ps  = predictions(recommenders, user, doc[:id])
  puts "#{i}: #{doc[:id]} - #{doc[:text]} (#{r.first.round(2)})"
  ps.each do |name,p|
    puts "  #{name}: #{p.round(2)}"
  end
end



