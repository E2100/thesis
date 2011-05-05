module MetaModel
class Model
  attr_reader :path

  def initialize(dataset)
    @path = Config::Data + dataset
  end

  def data
    @data ||= FileDataModel.new(java.io.File.new(@path))
  end

  def users
    data.getUserIDs.to_a
  end

  def items
    data.getItemIDs.to_a
  end

  def rating(userid,itemid)
    data.get_preference_value(userid,itemid)
  end

  def rated?(userid,itemid)
    !rating(userid,itemid).nil?
  end

  def user_ratings(userid)
    r = {}
    data.get_preferences_from_user(userid).each do |pref|
      r[pref.item_id] = pref.value
    end
    r
  end

  def item_ratings(itemid)
    r = {}
    data.get_preferences_for_item(itemid).each do |pref|
      r[pref.user_id] = pref.value
    end
    r
  end
 
  def self.rand(model,p)
    t = Config::Data + '/tmp/model' 
    d = File.open(model.path).read.split("\n")
    n = d.size
    m = (n * p).to_i
    
    r = []
    while r.size < m
      r << d[Kernel.rand(n)]
    end

    File.open(t, 'w') do |f|
      f.write(r.join("\n"))
    end
    Model.new('/tmp/model')
  end

end
end
