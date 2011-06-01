module AR
class AggregateRecommender

  def initialize(task, model)
    @task = task
    @model = model
    train_weights
  end 

  def estimate_preference(userid, itemid)
    ps = predictions(userid, itemid)
    return Float::NAN if ps.size == 0
    # .. something with predictions
    return 3.0
  end

  def recommenders
    @task[:recommenders]
  end

  def predictions(userid, itemid)
    {}.tap do |preds|
      recommenders.each do |name, recommender|
        p = recommender.prediction(userid, itemid)
        preds[name] = p unless p.nan? 
      end
    end
  end

  def train_weights

  end

end
end
