require 'lib/metamodel'

module MetaModel
  extend self

  def recommender_tasks
    {
      slope_one: Task.new({recommender: :slope_one}),
      item_average: Task.new({recommender: :item_average}),
      average:Task.new({recommender: :item_user_average}),
      generic_user: Task.new({recommender: :generic_user}),
      generic_item: Task.new({recommender: :generic_item}) 
    }
  end

  def meta_task(recs)
    Task.new({
      recommender: :meta,
      bagging: 1.0,
      recommenders: recs,
      nn_in: recs.size,
      nn_out: 1,
      nn_hidden: [recs.size + 1],
      nn_transfer: :sigmoid,
      nn_learning_rate: 0.3,
      nn_max_iterations: 100,
      nn_max_error: 0.001,
      nn_momentum: 0.0  
    })
  end

  def recommenders
    Perform.perform_all(recommender_tasks)
  end

  def meta_recommender
    Perform.perform(meta_task(recommenders))
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
rs = M.recommenders
ms = M.meta_recommender
rs[:meta] = ms
M.evaluate(rs)



