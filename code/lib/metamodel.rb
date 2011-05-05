# environment
raise "JRuby required"    unless RUBY_PLATFORM =~ /java/
raise "Ruby 1.9 required" unless RUBY_VERSION  =~ /^1.9/

# load path
$: << File.join(File.dirname(__FILE__), 'metamodel')

# std libs
require 'java'
require 'pp'
require 'csv'

# app libs
require 'lucene'
require 'mahout'
require 'neuroph'
require 'exceptions'
require 'log'
require 'scale'
require 'task'
require 'mlp'
require 'mlp_sets'
require 'linear'
require 'model'
require 'recommender'
require 'rmse_evaluator'
require 'rank_evaluator'
require 'perform'
require 'weights'
require 'meta'
require 'meta_recommender'
require 'meta_basic_recommender'
require 'meta_svd_recommender'

# config
module MetaModel
  module Config
    Data = File.expand_path(File.join(File.dirname(__FILE__), '..', 'data')) 
  end
end

