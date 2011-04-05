module MetaModel
class Slider

  def initialize(task, model)
    @task, @model = task, model
    create_file
    create_meta
  end
  
  def prediction(itemid)
    weights = {}
    preds = {}
    recommenders.each do |name,rec|
      begin
        p1 = @meta.prediction(index(name), itemid)
        p2 = rec.prediction(user, itemid)
        weights[name] = p1
        preds[name]   = p2
      rescue PredictionError
        weights[name] = 0.0
        preds[name]   = 0.0
      end
    end
    sum = weights.values.inject(:+)
    #puts weights
    weights.each do |k,v|
      weights[k] = v/sum
    end
    p = 0.0
    preds.each do |name,pred|
      p = p + weights[name] * pred
    end
    Scale.constrain p
  end

private
  
  def create_file
    rows = []
    @model.user_ratings(user).each do |item,rating|
      begin
        single_errors(item).each do |name,e|
          rows << [index(name), item, 1.0 / (e + 1.0)]
        end
      rescue PredictionError
      end
    end
    File.open('data/tmp', 'w') do |f|
      rows.each do |r|
        f.puts r.join(',')
      end
    end
  end

  def create_meta
    @meta = Perform.perform(meta_task)
  end

  def index(m)
    methods.index(m)
  end

  def meta_task
    Task.new(@task.clone.opts.merge({
      mission: :recommender,
      recommender: :svd,
      factorizer: :em,
      factorizer_features: 10,
      dataset: '/tmp'
    }))    
  end
 
  def user
    @task[:userid]
  end

  def recommenders
    @task[:recommenders]
  end

  def count
    recommenders.size.to_f
  end
  
  def correct(itemid)
    @model.rating(user,itemid)
  end

  def methods
    recommenders.keys.sort
  end

  def ordered_predictions(itemid)
    predictions(itemid).sort.map { |r| r.last }
  end

  def predictions(itemid)
    {}.tap do |preds|
      recommenders.each do |name,rec|
        preds[name] = rec.prediction(user,itemid)
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

end
end
