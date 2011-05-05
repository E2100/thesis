require 'lib/metamodel'
M = MetaModel

n = 5

mlp = M::MLP.new(M::Task.new({
  mission: :meta,
  nn_in: n,
  nn_out: 1,
  nn_hidden: [n*2, n*2],
  nn_transfer: :sigmoid,
  nn_learning_rate: 0.5,
  nn_max_iterations: 10000,
  nn_max_error: 0.00001,
  nn_momentum: 0.0 
}))

mlp.ror


