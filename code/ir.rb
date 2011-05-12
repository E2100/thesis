require 'pp'
require 'java'
require 'lib/metamodel'
M = MetaModel

l = M::Lucene::API.new
t = M::Task.new({
  dataset: '/movielens/movielens-1mm/movies.dat'
  #dataset: '/movielens/movielens-100k/meta/u.item'
})
l.index_documents(t)

