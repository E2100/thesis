require 'lib/metamodel'

module MetaModel
  extend self

  def recommender_tasks
    {
      svd1:         Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 10}),
      svd2:         Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 20}),
      svd3:         Task.new({recommender: :svd, factorizer: :em, factorizer_features: 10}),
      svd4:         Task.new({recommender: :svd, factorizer: :em, factorizer_features: 20}),
      slope_one:    Task.new({recommender: :slope_one}),
      item_average: Task.new({recommender: :item_average}),
      average:      Task.new({recommender: :item_user_average}),
      generic_user: Task.new({recommender: :generic_user}),
      generic_item: Task.new({recommender: :generic_item}) 
    }
  end
  
  def meta_tasks(recs)
    {
      m_average: Task.new({recommender: :meta_basic, meta_method: :average, recommenders: recs.clone}),
      m_median:  Task.new({recommender: :meta_basic, meta_method: :median,  recommenders: recs.clone}),
      m_max:     Task.new({recommender: :meta_basic, meta_method: :max,     recommenders: recs.clone}),
      m_min:     Task.new({recommender: :meta_basic, meta_method: :min,     recommenders: recs.clone}),
    }
  end

  def svd_task(recs)
    Task.new({
      recommender: :meta_svd,
      recommenders: recs.clone 
    })
  end

  def neural_task(recs)
    Task.new({
      recommender: :meta,
      bagging: 1.0,
      recommenders: recs.clone,
      nn_in: recs.size,
      nn_out: 1,
      nn_hidden: [recs.size * 2, recs.size * 2],
      nn_transfer: :sigmoid,
      nn_learning_rate: 0.5,
      nn_max_iterations: 1000,
      nn_max_error: 0.00001,
      nn_momentum: 0.0  
    })
  end

  def evaulator_task(recommenders)
   Task.new({
     mission: :rmse_evaluator,
     recommenders: recommenders,
   })
  end

  def evaluate(recommenders)
    r = Perform.perform(Task.new({
      mission: :rmse_evaluator,
      recommenders: recommenders,
    })).evaluate
    Log.evaluation(r)
  end
end

M  = MetaModel

recommenders = M::Perform.perform_all(M.recommender_tasks)
meta_basics  = M::Perform.perform_all(M.meta_tasks(recommenders))
meta_svd     = M::Perform.perform(M.svd_task(recommenders))
#meta_ann     = M::Perform.perform(M.neural_task(recommenders))

recommenders.merge!(meta_basics)
recommenders[:m_svd] = meta_svd
#recommenders[:m_neural] = meta_ann

M.evaluate(recommenders)


