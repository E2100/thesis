require 'java'
require 'lib/metamodel/lucene'

M = MetaModel

l = M::Lucene::API.new

l.add_document(1, 'hello1')
l.add_document(2, 'hello2')


