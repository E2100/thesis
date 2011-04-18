module MetaModel
class RankEvaluator
  
  def initialize(task)
    @task = task
  end
  
  def recommenders
    @task[:recommenders]
  end

  def recommendations(user, n = 10)
    {}.tap do |results|
      recommenders.each do |name,rec|
        results[name] = rec.recommend(user,n)
      end
    end
  end

  # ...

end
end
