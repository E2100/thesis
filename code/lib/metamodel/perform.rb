module MetaModel
class Perform
  
  def self.perform_all(tasks)
    tasks.each do |name,task|
      tasks[name] = Perform.new(task).perform
    end
    tasks
  end

  def self.perform(task)
    new(task).perform
  end

  def initialize(task)
    @task = task
  end

  def perform
    Log.task(@task)
    send(@task[:mission])
  end
  
  def recommender
    Recommender.new(@task)
  end

  def evaluator
    Evaluator.new(@task)
  end

end
end
