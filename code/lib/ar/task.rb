module AR
class Task

  def initialize(opts={})
    @opts = defaults(opts)     
  end
    
  # Default main task settings
  def main 
    {
      # recommender, rmse_evaluator, rank_evaluator
      mission: :recommender,

      # default dataset
      dataset: '/jester/splits/base/1',

      # default testset
      testset: '/jester/splits/test/1'
    }
  end
  
  # Default recommender settings
  def recommender
    {
      # type of recommender
      recommender: :svd,
      
      # similarity between users
      # euclidean, pearson, spearman, log, cosine
      user_similarity: :pearson,

      # similarity between items
      # euclidean, pearson, log, cosine
      item_similarity: :cosine,

      cluster_similarity: :kfn_cluster,
      neighborhood: :threshold,
      neighborhood_size: 1000,
      threshold: 0.2,
      clusters: 2000,
      
      # bootstrap aggregation percentage
      bagging: 0.2,

      # SVD factorizer
      # em, alswr
      factorizer: :alswr,
      factorizer_features: 50,
      factorizer_iterations: 10,
      factorizer_lambda: 0.08,

      # Cluster optimizers
      # conjugate, quadratic
      optimizer: :quadratic
    }
  end
  
  # Default evaluator settings
  def evaluator
    {
      evaluator: :rmse,
      training_percentage: 0.7,
      evaluation_percentage: 1.0,
      recommenders: {}
    }
  end

  # Default aggregation settings
  def aggregate
    {
      userid: 0,
      recommenders: {},
      method: :average,
      number_of_results: 10
    }
  end
  
  def defaults(opts)
    [
      main,
      recommender,
      evaluator,
      aggregate,
      opts
    ].inject(:merge)
  end
  
  def opts
    @opts
  end

  def [](key)
    @opts[key]
  end

  def []=(key,value)
    @opts[key] = value
  end

  def to_s
    @opts.to_s
  end

end
end
