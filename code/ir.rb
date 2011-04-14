require 'pp'
require 'java'
require 'lib/metamodel'
M = MetaModel

l = M::Lucene::API.new
#t = M::Task.new({
#  dataset: '/movielens/movielens-100k/meta/u.item'
#})
#l.index_documents(t)

pp l.serp(l.query('star').map { |x| x.last[:id] })
