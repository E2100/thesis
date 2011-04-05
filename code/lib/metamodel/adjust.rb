module MetaModel
class Adjust

  def initialize(task, model)
    @model = model
    @task  = task
    @user  = task[:userid]
    @count = task[:recommenders].size
    @recommenders = task[:recommenders]
    @weights = w0
    Log.out('Linear', @user)
    train_weights
    puts @weights
  end
  
  # CHANGE
  def prediction(itemid)
    r = 0.0
    predictions(itemid).each do |name,p|
      r += @weights[name] * p
    end
    r
  end

private

  def w0
    {}.tap do |ws|
      @recommenders.each do |name,rec|
        ws[name] = 0.0
      end
    end
  end

  def correct(itemid)
    @model.rating(@user,itemid)
  end
    
  # CHANGE
  def train_weights
    es = errors
    errors.each do |name,e|
      @weights[name] = 1.0 / e 
    end
    total = @weights.values.inject(:+)
    @weights.each do |name,w|
      next unless w and name and total
      @weights[name] = @weights[name] / total
    end
  end

  def predictions(itemid)
    {}.tap do |preds|
      @recommenders.each do |name,rec|
        preds[name] = rec.prediction(@user,itemid)
      end
    end
  end

  def single_errors(itemid)
    {}.tap do |errors|
      predictions(itemid).each do |name,pred|
        errors[name] = (correct(itemid) - pred) ** 2
      end
    end
  end

  def errors
    e = Hash.new { 0.0 }
    n = Hash.new { 0.0 }
    @model.user_ratings(@user).each do |i,r|
      begin
        single_errors(i).each do |name,error|
          raise PredictionError if error.nan?
          e[name] += error
          n[name] += 1.0
        end
      rescue PredictionError
      end
    end
    e
  end
  
end
end
