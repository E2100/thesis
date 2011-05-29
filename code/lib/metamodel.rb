# environment
raise "JRuby required"    unless RUBY_PLATFORM =~ /java/
raise "Ruby 1.9 required" unless RUBY_VERSION  =~ /^1.9/

# load path
$: << File.join(File.dirname(__FILE__), 'metamodel')

# std libs
require 'java'
require 'pp'
require 'csv'

# core ext
require 'ext/array'

# app libs
require 'lucene'
require 'mahout'
require 'exceptions'
require 'log'
require 'scale'
require 'task'
require 'perform'
require 'model'
require 'recommender'
require 'ranker'
require 'rmse_evaluator'
require 'rank_evaluator'
require 'aggregate_recommender'
require 'adaptive_recommender'

# config
module MetaModel
  module Config
    Data = File.expand_path(File.join(File.dirname(__FILE__), '..', 'data')) 
  end
end

