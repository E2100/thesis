require 'java'
require 'pp'
require 'mahout'

module MetaModel
  extend self

  def sets
    [
      [0.768309712409973,
       0.80978262424469,
       0.733904242515564,
       0.700951218605041,
       0.692455470561981],
      [0.768309712409973,
       0.80978262424469,
       0.733904242515564,
       0.700951218605041,
       0.692455470561981]
    ]
  end

  def w0
    [ 1.0/5.0 ] * 5
  end

  def correct
    [
      0.75,
      0.75
    ]
  end

  def errors
    errors = []
    sets.each_with_index do |set,i|
      c = correct[i]
      errors << []
      set.each do |val|
        errors.last << (c-val)**2
      end
    end
    errors
  end

  def error(sets,correct,weights)
    tot = 0.0
    sets.each_with_index do |set,i|
      set.each_with_index do |val,j|
        tot += ((weights[i] * val) - correct) ** 2
      end
    end
    tot
  end
  
  def test
    #o = ConjugateGradientOptimizer.new
    #pp o.optimize(sets, errors)
    pp sets
    puts '-'*100
    pp errors
    #pp error(sets,correct.first, w0)
  end

end

MetaModel.test





