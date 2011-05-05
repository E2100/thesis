class Array; def sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end
class Array; def mean; self.sum/self.size.to_f; end; end
class Array; def variance; mean = self.mean; Math.sqrt(inject( nil ) { |var,x| var ? var+((x-mean)**2) : ((x-mean)**2)}/self.size.to_f); end; end


module MetaModel

# Multilayer Perceptron
class MLP
   
  def initialize(task)
    @task = task
    @off = false
    create_net
  end

  def create_net
    @net = MultiLayerPerceptron.new(
      send(@task[:nn_transfer]),
      @task[:nn_in],
      *@task[:nn_hidden],
      @task[:nn_out]
    )
    #@net = Perceptron.new(
    #  @task[:nn_in],
    #  @task[:nn_out],
    #  send(@task[:nn_transfer])
    #)
  end

  # training_elements: [[in1,..,inN], [out1,..outM]]
  def to_supervised_training_elements(training_elements)
    training_elements.map do |e|
      next if e[0].include?(Float::NAN)

      e[0].map! { |x| x.round(3) }
      SupervisedTrainingElement.new(
        e[0].to_java(Java::double),
        e[1].to_java(Java::double))
    end
  end

  def to_training_set(training_elements)
    training_elements = to_supervised_training_elements(training_elements)
    training_set = TrainingSet.new(@task[:nn_in], @task[:nn_out])
    training_elements.each { |e| training_set.add_element(e) }
    training_set
  end

  def train(training_elements)
    n = (training_elements.size + 1).to_f
    #puts "n: #{n}"
    #if n < 20
    #  @off = true
    #  return
    #end

    mx = @task[:nn_max_iterations] 
    lr = @task[:nn_learning_rate]
    me = @task[:nn_max_error]
    mm = @task[:nn_momentum]

    @net.learning_rule = MomentumBackpropagation.new
    @net.learning_rule.batch_mode      = false
    @net.learning_rule.max_iterations  = mx
    @net.learning_rule.learning_rate   = lr
    @net.learning_rule.max_error       = me
    @net.learning_rule.momentum        = mm
    @net.learn_in_same_thread(to_training_set(training_elements))
    
    #test(training_elements) 
    #o = []
    #training_elements.each do |e|
    #  o << output(e[0])
    #end
    #puts "o: #{o.variance}"
    #@off = true if o.variance < 0.1
  end


  def output(input)
    raise PredictionError if @off
    #return input[4]
    #return Float::NAN if @net.learning_rule.total_network_error > 0.02
    raise ArgumentError, "NaN as ANN input" if input.any? { |x| x.nan? }
    input = input.to_java(Java::double)
    @net.set_input(input) 
    @net.calculate
    @net.output.to_a[0]
  end

  def test_elements(elements)
    pp elements
    puts '-'*100
    err = [0.0] * 5
    num = [0.0] * 5
    elements.each do |element|
      inp = element[0]
      cor = element[1][0]
      pp inp
      pp cor

      inp.each_index do |ix|
        err[ix] += (Scale.to_stars(inp[ix])-Scale.to_stars(cor)) ** 2
        num[ix] += 1.0
      end
    end
    pp err
    pp num
    err.each_index do |ix|
      err[ix] = Math.sqrt( err[ix] - num[ix] )
    end
    err
  end

  def test(elements)
    training_set = to_training_set(elements)
    err = 0.0
    training_set.training_elements.each do |e|
      i = e.input.to_a
      begin
        o = output(i)
      rescue PredictionError
        next
      end
      d = e.desired_output.to_a[0]
      er = (Scale.to_stars(o)-Scale.to_stars(d)) ** 2
      next if er.nan?
      err += er
      puts "input:  #{i.map {|x| x.round(1)}}, \t o/c: #{o.round(2)} | #{d}, \t diff: #{(o-d).abs.round(3)}"
    end
    rmse = Math.sqrt(err / elements.size.to_f)
    puts "neterr: #{@net.learning_rule.total_network_error}"
    puts "rmse: #{rmse}"
    return rmse
  end
  
  def xor
    ts = [
      [[0.0, 0.0], [0.0]],
      [[0.0, 1.0], [1.0]],
      [[1.0, 0.0], [1.0]],
      [[1.0, 1.0], [0.0]],
    ]
    train(ts)
    test(ts)
  end

  def ror
    #Log.task(@task)
    tss = MLPSets::Sets
    err = 0.0
    num = 0.0
    1.times do
      tss.each do |ts|
        train(ts)
        err += test(ts)
        num += 1.0
      end
    end
    puts '-'*100
    avg = Math.sqrt(err/num)
    puts "avg: #{avg}"
  end
  
  # transfer functions

  def tanh
    TransferFunctionType::TANH
  end
  
  def sigmoid
    TransferFunctionType::SIGMOID
  end 

  def gaussian
    TransferFunctionType::GAUSSIAN
  end

  def linear
    TransferFunctionType::LINEAR
  end

  def ramp
    TransferFunctionType::RAMP
  end

  def sgn
    TransferFunctionType::SGN
  end

  def step
    TransferFunctionType::STEP
  end

  def trapezoid
    TransferFunctionType::TRAPEZOID
  end

end
end
