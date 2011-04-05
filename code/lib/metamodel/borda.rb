module MetaModel
class Borda
  
  def initialize(task, model=nil)
    @task = task
    @user = task[:userid]
    @recs = task[:recommenders]
  end 

  def recommend(n)
    c = n
    r = {}
    s = Hash.new { 0 }
    @recs.each do |name,rec|
      r[name] = rec.recommend(@user, n).map { |item| item.item_id }
      puts r[name]
      puts '-'*100
    end
    r.each do |name,recs|
      recs.each do |itemid|
        s[itemid] = s[itemid] + (c - recs.index(itemid))
      end
    end
    puts s 

    s
  end

end
end
