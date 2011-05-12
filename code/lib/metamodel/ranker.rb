module MetaModel
class Ranker
  
  def initialize(task)
    @task = task
  end

  def recommenders
    @task[:recommenders]
  end

  def ir(q)
    Lucene::API.new.query(q, @task[:number_of_results])
  end

  def predictions(userid, itemid)
    {}.tap do |preds|
      recommenders.each do |name, recommender|
        p = recommender.prediction(userid, itemid)
        preds[name] = p unless p.nan? or p.nil? 
      end
    end
  end

  def prediction(userid, query)
    results = {}
    ir(query).each do |item|
      score = @task[:ir_w] * item.first
      data  = item.last
      id    = data[:id]
      title = data[:text]
      results[id] = {
        id: id,
        title: title,
        ir: item.first,
        score: score
      }
      predictions(userid, id).each do |pred|
        puts "PRED: #{pred}"

        results[id][pred.first] = pred.last # method score
        results[id][:score] += pred.last # total score
      end
    end
    results
  end

end
end
