require 'lib/metamodel'
M = MetaModel

# create standard recommenders
recommender_tasks = {
  #knn_item:  M::Task.new({recommender: :knn_item}),
  #random:  M::Task.new({recommender: :random}),
  #cluster:  M::Task.new({recommender: :tree_cluster})

  #svd1: M::Task.new({recommender: :svd}),
  #svd2: M::Task.new({recommender: :svd, factorizer: :em}),
  slope_one: M::Task.new({recommender: :slope_one}),
  item_average: M::Task.new({recommender: :item_average}),
  #average: M::Task.new({recommender: :item_user_average}),
  #generic_user: M::Task.new({recommender: :generic_user}),
  #generic_item: M::Task.new({recommender: :generic_item}) 
}
recommenders = M::Perform.perform_all(recommender_tasks)

meta_task = M::Task.new({
  userid: 1,
  recommender: :meta,
  recommenders: recommenders.clone
})

m = M::Perform.perform(meta_task)

puts m.prediction(1,1)
puts m.prediction(1,2)
puts m.prediction(1,3)
puts m.prediction(1,4)
puts m.prediction(1,5)


