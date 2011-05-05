module MetaModel
class Recommender

  def initialize(task)
    @task = task
    recommender
  end

  def prediction(userid,itemid)
    begin
      recommender.estimate_preference(userid,itemid)
    rescue NativeException
      #raise PredictionError
      #0.0
      Float::NAN
    end
  end
  
  def recommend(userid,n)
    recommender.recommend(userid,n).map do |rec_item|
      [
        rec_item.get_value, 
        {id: rec_item.get_item_id}
      ]
    end
  end

  def recommender
    @recommender ||= send(@task[:recommender])
  end

private

  def model
    if @task[:bagging] < 1.0
      # bootstrap aggregation
      Model.rand(Model.new(@task[:dataset]), @task[:bagging])
    else
      Model.new(@task[:dataset])
    end
  end
  
  # recommenders

  def generic_user
    sim = send(@task[:user_similarity])
    knn = send(@task[:neighborhood])
    GenericUserBasedRecommender.new(model.data, knn, sim)
  end
  
  def generic_item
    GenericItemBasedRecommender.new(model.data,
      send(@task[:item_similarity]))
  end

  def slope_one
    SlopeOneRecommender.new(model.data)
  end
  
  def item_average
    ItemAverageRecommender.new(model.data)
  end
  
  def item_user_average
    ItemUserAverageRecommender.new(model.data)
  end

  def random
    RandomRecommender.new(model.data)
  end

  def svd
    SVDRecommender.new(model.data, send(@task[:factorizer]))
  end
  
  def tree_cluster
    TreeClusteringRecommender2.new(
      model.data,
      send(@task[:cluster_similarity]),
      @task[:clusters])
  end

  def meta
    MetaRecommender.new(@task, model)
  end
  
  def meta_basic
    MetaBasicRecommender.new(@task, model)
  end 

  def meta_svd
    MetaSVDRecommender.new(@task, model)
  end
  

  # neighborhoods

  def knn
    NearestNUserNeighborhood.new(
      @task[:neighborhood_size], 
      send(@task[:user_similarity]),
      model.data)
  end

  def threshold
    ThresholdUserNeighborhood.new(
      @task[:threshold],
      send(@task[:user_similarity]),
      model.data)
  end
  
  def knn_cluster
    NearestNeighborClusterSimilarity.new(
      send(@task[:user_similarity]))
  end

  def kfn_cluster
    FarthestNeighborClusterSimilarity.new(
      send(@task[:user_similarity])) 
  end

  # similarity
  
  def euclidean
    EuclideanDistanceSimilarity.new(model.data)
  end

  def pearson
    PearsonCorrelationSimilarity.new(model.data) 
  end

  def spearman
    SpearmanCorrelationSimilarity.new(model.data)
  end

  def log
    LogLikelihoodSimilarity.new(model.data)
  end

  def cosine
    UncenteredCosineSimilarity.new(model.data)
  end

  # svd factorizers

  def em
    ExpectationMaximizationSVDFactorizer.new(model.data, 
      @task[:factorizer_features],
      @task[:factorizer_iterations])
  end

  # http://www.hpl.hp.com/personal/Robert_Schreiber/
  # papers/2008%20AAIM%20Netflix/netflix_aaim08(submitted).pdf
  def alswr
    ALSWRFactorizer.new(model.data,
      @task[:factorizer_features],
      @task[:factorizer_lambda],
      @task[:factorizer_iterations])
  end
  
  # optimizers

  def conjugate
    ConjugateGradientOptimizer.new
  end

  def quadratic
    NonNegativeQuadraticOptimizer.new
  end

end
end
