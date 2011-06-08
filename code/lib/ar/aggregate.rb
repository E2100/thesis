module AR
class AggregateRecommender

  def initialize(task, model)
    @task = task
    @model = model
  end 

  def estimate_preference(userid, itemid)
    ps = predictions(userid, itemid)
    return Float::NAN if ps.size == 0
    send(@task[:method], ps)
  end

  def average(ps)
    w = 1.0 / ps.size.to_f
    ps.values.inject(0) { |sum,n| sum + (w * n) }
  end

  def max(ps)
    ps.values.sort.last
  end

  def min(ps)
    ps.values.sort.first
  end

  def median(ps)
    v = ps.values.sort
    s = v.size 
    m = (s/2).to_i
    if s.odd?
      v[m]
    else
      (v[m-1] + v[m]).to_f / 2.0
    end
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

end
end
