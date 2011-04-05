module MetaModel
class Meta
  attr_reader :rmse

  def initialize(task, model)
    if task[:userid] % 100 == 0 
      Log.out('Creating meta model for user', task[:userid]) 
    end
    @task  = task
    raise NestingError if @task[:recommenders].key?(:meta)
    @model = model
    @net   = create_net
  end
  
  def prediction(itemid)
    recs = recommendations(itemid)
    ord  = ordered(recs)
    input  = ord.map { |e| Scale.from_stars(e) }
    Scale.to_stars @net.output(input)
  end
  
private

  def create_net
    MLP.new(@task).tap do |net|
      sets = training_sets
      net.train(sets)
    end
  end
  
  def training_sets
    [].tap do |results|
      @model.user_ratings(@task[:userid]).each do |itemid,rating|
        recs = ordered(recommendations(itemid))
        next unless recs.size > 0
        recs.map! { |r| Scale.from_stars(r) } 
        results << [recs, [Scale.from_stars(rating)]]
      end
    end
  end

  def recommendations(itemid)
    {}.tap do |results|
      @task[:recommenders].each do |name,rec|
        begin
          p = rec.prediction(@task[:userid],itemid)
          results[name] = p.nan? ? 0.0 : p
        rescue PredictionError
          results[name] = 0.0
        end
      end
    end
  end

  def ordered(recommendations)
    recommendations.sort.map { |r| r.last }
  end

end
end
