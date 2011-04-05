require 'lib/metamodel'
M = MetaModel

if not true
  n = 5
  mlp = M::MLP.new(M::Task.new({
    mission: :meta,
    nn_in: n,
    nn_out: 1,
    #nn_hidden: [1],
    nn_transfer: :sigmoid,
    nn_learning_rate: 0.3,
    nn_max_iterations: 100,
    nn_max_error: 0.001,
    nn_momentum: 0.0 
  }))
  mlp.ror
  exit
end


def perform
  # create standard recommenders
  recommender_tasks = {
    #knn_item:  M::Task.new({recommender: :knn_item}),
    #random:  M::Task.new({recommender: :random}),
    #cluster:  M::Task.new({recommender: :tree_cluster})

    #svd1: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 1}),
    #svd2: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 2}),
    #svd3: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 3}),
    #svd4: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 4}),
    #svd5: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 5}),
    #svd6: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 6}),
    #svd7: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 7}),
    #svd8: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 8}),
    #svd9: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 9}),
    #svda: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 30}),
    #svdb: M::Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 50}),
    #svd10: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 1}),
    #svd11: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 2}),
    #svd12: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 3}),
    #svd13: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 4}),
    #svd14: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 5}),
    #svd15: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 6}),
    #svd16: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 7}),
    #svd17: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 8}),
    #svd18: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 9}),
    #svdc: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 30}),
    #svdd: M::Task.new({recommender: :svd, factorizer: :em, factorizer_features: 50}),
    slope_one: M::Task.new({recommender: :slope_one}),
    item_average: M::Task.new({recommender: :item_average}),
    average: M::Task.new({recommender: :item_user_average}),
    generic_user: M::Task.new({recommender: :generic_user}),
    generic_item: M::Task.new({recommender: :generic_item}) 
  }
  recommenders = M::Perform.perform_all(recommender_tasks)

  # create meta recommender
  if true
    n = recommenders.size
    meta_recommender_task = M::Task.new({
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
    })
    meta_recommender = M::Perform.perform(meta_recommender_task)
    recommenders[:meta] = meta_recommender
  end

  # evaluate
  evaluator_task = M::Task.new({
    mission: :evaluator,
    recommenders: recommenders,
  })
  ev  = M::Perform.perform(evaluator_task)
  res = ev.evaluate
  M::Log.evaluation(res)
  return res
end

rs = []
1.times do
  rs << perform
end

exit
puts 
puts
puts '-'*100
puts rs
puts '-'*100
pp rs
puts '-'*100
puts



