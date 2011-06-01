# Require Mahout jars and dependencies
Dir[File.join(File.dirname(__FILE__),'mahout','**','*.jar')].each do |jar|
  require jar
end

module AR
  
  # Data model
  import org.apache.mahout.cf.taste.impl.model.GenericDataModel
  import org.apache.mahout.cf.taste.impl.model.file.FileDataModel
  import org.apache.mahout.cf.taste.example.grouplens.GroupLensDataModel

  # Similarity
  import org.apache.mahout.cf.taste.impl.similarity.EuclideanDistanceSimilarity
  import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity
  import org.apache.mahout.cf.taste.impl.similarity.SpearmanCorrelationSimilarity
  import org.apache.mahout.cf.taste.impl.similarity.LogLikelihoodSimilarity
  import org.apache.mahout.cf.taste.impl.similarity.UncenteredCosineSimilarity 

  # Neighborhoods
  import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood
  import org.apache.mahout.cf.taste.impl.neighborhood.ThresholdUserNeighborhood
  import org.apache.mahout.cf.taste.impl.recommender.NearestNeighborClusterSimilarity
  import org.apache.mahout.cf.taste.impl.recommender.FarthestNeighborClusterSimilarity

  # Optimizers
  import org.apache.mahout.cf.taste.impl.recommender.knn.ConjugateGradientOptimizer
  import org.apache.mahout.cf.taste.impl.recommender.knn.NonNegativeQuadraticOptimizer
  
  # Factorizers
  import org.apache.mahout.cf.taste.impl.recommender.svd.ExpectationMaximizationSVDFactorizer
  import org.apache.mahout.cf.taste.impl.recommender.svd.ALSWRFactorizer

  # Recommenders
  import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender
  import org.apache.mahout.cf.taste.impl.recommender.GenericItemBasedRecommender
  import org.apache.mahout.cf.taste.impl.recommender.slopeone.SlopeOneRecommender
  import org.apache.mahout.cf.taste.impl.recommender.svd.SVDRecommender
  import org.apache.mahout.cf.taste.impl.recommender.knn.KnnItemBasedRecommender
  import org.apache.mahout.cf.taste.impl.recommender.ItemAverageRecommender
  import org.apache.mahout.cf.taste.impl.recommender.ItemUserAverageRecommender
  import org.apache.mahout.cf.taste.impl.recommender.TreeClusteringRecommender
  import org.apache.mahout.cf.taste.impl.recommender.TreeClusteringRecommender2
  import org.apache.mahout.cf.taste.impl.recommender.RandomRecommender

  # Evaluators
  import org.apache.mahout.cf.taste.impl.eval.LoadEvaluator
  import org.apache.mahout.cf.taste.impl.eval.RMSRecommenderEvaluator
  import org.apache.mahout.cf.taste.impl.eval.GenericRecommenderIRStatsEvaluator

end
