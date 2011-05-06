module MetaModel
class MetaSVDRecommender
  
  def initialize(task, model)
    Log.task(task)
    @task         = task
    @model        = model
    @recommenders = task[:recommenders]
    @error_models = create_error_models
    @svds         = create_svds
  end

  def estimate_preference(userid, itemid)
    es = estimate_errors(userid, itemid)
    return Float::NAN if es.size == 0

    weights = errors_to_weights(es)
    result = 0.0
    weights.each do |name, w|
      p = @recommenders[name].prediction(userid, itemid)
      return Float::NAN if p.nan?
      result += weights[name] * p
    end 
    result
  end

private

  def errors_to_weights(errors)
    weights = {}
    
    # normalize errors
    sorted = errors.sort { |a,b| a.last <=> b.last }
    xmax   = sorted.last.last
    xmin   = sorted.first.last
    sorted.map! do |x| 
      [x.first, normalize(x.last,xmin,xmax,0.0,1.0)]
    end  

    # turn errors to weights
    sorted.each do |method, error|
      weights[method] = 1.0 - error
    end

    # normalize weights
    sum = weights.values.inject(:+)
    weights.each do |method, weight|
      weights[method] = weight == 0.0 ? 0.0 : weight / sum 
    end
    weights
  end

  def normalize(x,xmin,xmax,ymin,ymax)
    xrange = xmax-xmin
    yrange = ymax-ymin
    ymin + (x-xmin) * (yrange.to_f / xrange) 
  end

  def estimate_errors(userid, itemid)
    {}.tap do |error_estimates|
      @svds.each do |name,svd|
        begin
          error_estimates[name] = svd.estimate_preference(userid, itemid)
        rescue NativeException
          Float::NAN
        end
      end
    end
  end

  def create_svds
    {}.tap do |s| 
      @recommenders.each do |name, recommender|
        s[name] = create_svd(name)
        puts '-'*100
      end
    end
  end

  def create_svd(method)
    Log.out('Meta SVD for', method)
    m = @error_models[method]
    pp m.users.size
    pp m.items.size
    data  = m.data
    SVDRecommender.new(
      data,
      ExpectationMaximizationSVDFactorizer.new(
        data, 
        20, #@task[:factorizer_features],
        20 #@task[:factorizer_iterations]
      )) 
      #ALSWRFactorizer.new(
      #  data,
      #  10,  #@task[:factorizer_features],
      #  0.01, #@task[:factorizer_lambda],
      #  10   #@task[:factorizer_iterations]
      #))
  end

  def create_error_models
    {}.tap do |models|
      @recommenders.each do |name, recommender|
        models[name] = create_error_model(name)
      end
    end
  end
  
  def create_error_model(method)
    Log.out('Starting error model for', method)
    errors = []
    @model.users.each do |userid|
      @model.user_ratings(userid).each do |itemid, rating|
        e = error(method, userid, itemid, rating)
        if not e.nan?
            errors << [userid, itemid, e]
        else
          errors << [userid, itemid, 4]
        end
      end
    end
    Log.out('Writing error model tmp for', method)
    path = '/tmp/meta_svd.' + method.to_s 
    File.open(Config::Data + path, 'w') do |f|
      f.write(errors.map { |e| e.join(",") }.join("\n"))
    end
    Model.new(path)
  end
  
  def error(method, userid, itemid, rating)
    recommender = @recommenders[method]
    prediction  = recommender.prediction(userid,itemid)
    correct     = @model.rating(userid, itemid)
    (correct-prediction).abs
  end

end
end
