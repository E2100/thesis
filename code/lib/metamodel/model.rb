module MetaModel
class Model

  def initialize(dataset)
    @data = FileDataModel.new(java.io.File.new(
      Config::Data + dataset))
  end

  def data
    @data
  end

  def users
    @data.getUserIDs.to_a
  end

  def items
    @data.getItemIDs.to_a
  end

  def rating(userid,itemid)
    @data.get_preference_value(userid,itemid)
  end

  def rated?(userid,itemid)
    !rating(userid,itemid).nil?
  end

  def user_ratings(userid)
    r = {}
    @data.get_preferences_from_user(userid).each do |pref|
      r[pref.item_id] = pref.value
    end
    r
  end

  def item_ratings(itemid)
    r = {}
    @data.get_preferences_for_item(itemid).each do |pref|
      r[pref.user_id] = pref.value
    end
    r
  end

end
end
