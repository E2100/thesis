require 'pp'
require 'lib/metamodel'
M = MetaModel

def recommenders
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

recommenders.each do |name,rec|
  puts '-'*10
  M::Log.hits( rec.recommend(1,10) )
end




#l = M::Lucene::API.new
#t = M::Task.new({
#  dataset: '/movielens/movielens-100k/meta/u.item'
#})
#l.index_documents(t)
#pp l.serp(l.query('star').map { |x| x.last[:id] })
