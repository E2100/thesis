require 'lib/metamodel'

module MetaModel
  extend self

  def recommender_tasks(opts)
    {
      svd1:       Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 10}.merge(opts)),
      svd2:       Task.new({recommender: :svd, factorizer: :alswr, factorizer_features: 20}.merge(opts)),
      svd3:       Task.new({recommender: :svd, factorizer: :em, factorizer_features: 10}.merge(opts)),
      svd4:       Task.new({recommender: :svd, factorizer: :em, factorizer_features: 20}.merge(opts)),
      knn:        Task.new({recommender: :generic_user}.merge(opts)),
      item_avg:   Task.new({recommender: :item_average}.merge(opts)),
      slope_one:  Task.new({recommender: :slope_one}.merge(opts)),
      baseline:   Task.new({recommender: :item_user_average}.merge(opts)),
      cosine:     Task.new({recommender: :generic_item}.merge(opts)) 
    }
  end
  
  def aggregator_tasks(recs, opts)
    {
      average: Task.new({recommender: :aggregate, method: :average, recommenders: recs.clone}.merge(opts)),
      median:  Task.new({recommender: :aggregate, method: :median,  recommenders: recs.clone}.merge(opts)),
    }
  end

  def adaptive_task(recs, opts)
    Task.new({
      recommender: :adaptive,
      recommenders: recs.clone,
      bagging: 1.0 
    }.merge(opts))
  end

  def evaluate(recommenders, opts)
    result = Perform.perform(Task.new({
      mission: :rmse_evaluator,
      recommenders: recommenders,
      bagging: 1.0
    }.merge(opts))).evaluate
    Log.evaluation(result)
    result
  end

  def recommenders(opts = {})
    rs = Perform.perform_all(M.recommender_tasks(opts))
    ms = Perform.perform_all(M.aggregator_tasks(rs, opts)) 
    ad = Perform.perform(M.adaptive_task(rs, opts))
    rs.merge!(ms)
    rs[:adaptive] = ad
    rs
  end
end
