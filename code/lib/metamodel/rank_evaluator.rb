module MetaModel
class RankEvaluator
  
  def initialize(task)
    @task   = task
    @test   = Model.new(task[:testset])
    @ranker = task[:ranker]
  end
 
  def users
    @test.users
  end

  def user_ratings(userid)
    @test.user_ratings(userid)
  end
 
  def correct(userid,itemid)
    @test.rating(userid,itemid)
  end 

  def ir(q)
    Lucene::API.new.query(q, @task[:number_of_results])
  end

  def predicted_ranking
    p = @ranker.prediction(10, @task[:query]) 
    list = []
    p.each do |item|
      pp item
      list << [item.last[:score], item.last ]
    end
    list.sort.reverse
  end

  def list_by(preds, key)
    list = []
    preds.each do |item|
      list << [item.last[key], item.last[:id], item.last[:title][0,10]]
    end
    list.sort.reverse
  end

  def evaluate
    ps = predicted_ranking
    ir = list_by(ps, :ir)    # ir ranking
    st = list_by(ps, :stack) # stacked model ranking
    cm = list_by(ps, :score) # combined ranking
    [ir, st, cm]
  end

end
end
