# Require Neuroph jars and dependencies
Dir[File.join(File.dirname(__FILE__),'neuroph','**','*.jar')].each do |jar|
  require jar
end

module MetaModel

  # Basic
  import org.neuroph.nnet.Neuroph
  import org.neuroph.nnet.Perceptron
  import org.neuroph.nnet.MultiLayerPerceptron
  import org.neuroph.core.NeuralNetwork
  import org.neuroph.util.NeuronProperties

  # Learning
  import org.neuroph.core.learning.SupervisedTrainingElement
  import org.neuroph.core.learning.TrainingElement
  import org.neuroph.core.learning.TrainingSet
  import org.neuroph.nnet.learning.MomentumBackpropagation
  import org.neuroph.nnet.learning.DynamicBackPropagation
  import org.neuroph.nnet.learning.CompetitiveLearning

  # Transfer
  import org.neuroph.util.TransferFunctionType

end
