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
      #next if u > 1
      @meta[u] = Meta.new(meta_task(u), @model)
      #@meta[u] = Weights.new(meta_task(u), @model)
    end
  end 

  def estimate_preference(userid,itemid)
    p = @meta[userid].prediction(itemid)
    #return p if p.nan?
    #Scale.constrain(p)
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

end
end
