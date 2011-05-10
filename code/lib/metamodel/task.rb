module MetaModel
class Task

  def initialize(opts={})
    @opts = defaults(opts)     
  end

  def main 
    {
      # recommender, rmse_evaluator, rank_evaluator
      mission: :recommender,
      
      #dataset: '/movielens/movielens-100k/base/60/u1.base.60',
      #testset: '/movielens/movielens-100k/base/40/u1.base.40'
      dataset: '/movielens/movielens-100k/base/100/u1.base',
      testset: '/movielens/movielens-100k/test/u1.test'
      #dataset: '/jester/50/u1',
      #testset: '/jester/20/u1'
    }
  end

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

  def evaluator
    {
      evaluator: :rmse,
      training_percentage: 0.7,
      evaluation_percentage: 1.0,
      recommenders: {}
    }
  end

  def neural_net
    {
      nn_in: 2,
      nn_out: 1,
      nn_hidden: 5,
      nn_transfer: :sigmoid,
      nn_learning_rate: 0.01,
      nn_max_iterations: 100,
      nn_max_error: 0.00001,
      nn_momentum: 0.0
    }
  end

  def meta
    {
      userid: 0,
      recommenders: {},
      meta_method: :average,
      number_of_results: 10
    }
  end
  
  def defaults(opts)
    [
      main,
      recommender,
      evaluator,
      neural_net,
      meta,
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
