module AR
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
    p = @ranker.prediction(@task[:userid], @task[:query]) 
    list = []
    p.each do |item|
      pp item
      list << [item.last[:score], item.last ]
    end
    list
  end

  def list_by(preds, key)
    list = []
    preds.each do |item|
      next if item.last[key].nil?
      list << [item.last[key], item.last[:id], item.last[:title]]
    end
    puts
    puts "LIST, #{key}"
    puts '-'*100
    pp list
    puts 
    list.sort { |a,b| b.first <=> a.first }
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
