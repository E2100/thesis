module MetaModel
class Weights
  
  def initialize(task, model)
    @task  = task
    @model = model
    w
  end

  def prediction(itemid)
    s = 0.0
    ws = w.clone
    recommenders.each do |name,rec|
      p = rec.prediction(user,itemid)
      if p.nan?
        ws = dissipate(ws,name)
      else
        s += ws[name] * p
      end
    end
    s
  end

private
  
  def user
    @task[:userid]
  end

  def recommenders
    @task[:recommenders]
  end

  def n
    recommenders.size
  end

  def w
    @w ||= {}.tap do |weights|
      recommenders.each do |name,rec|
        weights[name] = 1.0 / n.to_f
      end
    end
  end

  def dissipate(ws,key)
    x = ws[key]
    ws.delete(key)
    ws.each do |k,v|
      ws[k] = v + (x / ws.size.to_f)
    end
    ws
  end

  def recommendations(itemid)
    {}.tap do |results|
      recommenders.each do |name,rec|
        begin
          p = rec.prediction(@task[:userid],itemid)
          results[name] = p.nan? ? 0.0 : p
        rescue PredictionError
          results[name] = 0.0
        end
      end
    end
  end

end
end
