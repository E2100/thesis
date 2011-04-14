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


query = 'war'
user  = 1

ir = M::Lucene::API.new
results = ir.query(query,10)
recommenders = make_recommenders

results.each_with_index do |r,i|
  doc = r.last
  print "#{i}: #{doc[:id]} - #{doc[:text]} (#{r.first.round(2)})\t| "
  recommenders.each do |name,rec|
    begin
      p = rec.prediction(user,doc[:id])
      next if p.nan?
      print "#{name}: #{rec.prediction(user,doc[:id])} | "
    rescue M::PredictionError
    end
  end
  puts
end


