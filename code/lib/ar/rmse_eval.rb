module AR
class RMSEEvaluator
  
  def initialize(task)
    @task  = task
    @test  = Model.new(task[:testset])
    @recommenders = task[:recommenders]
  end

  def evaluate
    errors
  end

private

  def users
    @test.users
  end

  def user_ratings(userid)
    @test.user_ratings(userid)
  end
 
  def correct(userid,itemid)
    @test.rating(userid,itemid)
  end 

  def predictions(userid,itemid)
    ps = {}
    @recommenders.each do |name,rec|
      ps[name] = rec.prediction(userid,itemid)
    end
    ps
  end

  def single_errors(userid,itemid)
    {}.tap do |errors|
      predictions(userid,itemid).each do |name,pred|
        errors[name] = (correct(userid,itemid) - pred) ** 2
      end
    end
  end
  
  def report_predictions(userid,itemid,ps)
    ps = ps.clone
    ps = ps.each { |k,v| ps[k] = v.round(2) }
    puts "#{userid} \t #{correct(userid,itemid)} \t #{ps} \t #{user_ratings(userid).size}"
  end

  def report_errors(userid,itemid,e,n)
    e = e.clone
    e = e.each { |k,v| e[k] = Math.sqrt(v/n[k]).round(2) }
    puts "(#{n.values.first}) #{e}"
  end
 
  def errors
    e = Hash.new { 0.0 }
    n = Hash.new { 0.0 }
    users.each do |u|
      if u % 100 == 0
        Log.out('evaluating user', u)
      end
      user_ratings(u).each do |i,r|
        single_errors(u,i).each do |name,error|
          begin
            raise PredictionError if error.nan?
            e[name] += error
            n[name] += 1.0
          rescue PredictionError
          end
        end
      end
    end
    {}.tap do |errors|
      e.each do |name,error|
        errors[name] = Math.sqrt(error/n[name])
      end
    end
  end
  
end
end
