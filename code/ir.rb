require 'pp'
require 'java'
require 'lib/metamodel/lucene'

M = MetaModel

l = M::Lucene::API.new

l.add_document(1, 'hello hello hello1')
l.add_document(2, 'hello hello2')

puts l.query('hello')
