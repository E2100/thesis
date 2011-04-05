module MetaModel
class MetaRecommender
  attr_reader :meta

  def initialize(task, model)
    @task = task
    @model = model
    @meta = {}
    create_metas
  end 

  def create_metas
    @model.users.each do |u|
      Log.out('Meta model for',u)
      #next if u > 1
      @meta[u] = Meta.new(meta_task(u), meta_model)
      #@meta[u] = Slider.new(meta_task(u), meta_model)
      #@meta[u] = Linear.new(meta_task(u), meta_model)
    end
  end 

  def estimate_preference(userid,itemid)
    p = @meta[userid].prediction(itemid)
    #p = Scale.constrain Scale.to_stars(p)
    raise PredictionError if p.nan?
    p
  end

  def meta_task(userid)
    others = @task[:recommenders]
    others.delete(:meta)
    Task.new(@task.clone.opts.merge({
      mission: :meta,
      userid: userid,
      recommenders: others,
      nn_in: others.size
    }))
  end

  def meta_model
    @meta_model ||= Model.new(@task[:metaset])
  end

end
end
