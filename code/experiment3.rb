require 'experiments'

queries = [
  "paris",
  #'"new york" or washington',
  #"star trek",
  #"man life summer",
  #"man", "life", "day", "star", "time", "night", 
  #"paris", "city", "death", "boys", "king", "story", 
  #"home", "movie", "american", "sea", "world", "fear", 
  #"girl", "house", "secret", "bad", "family", "america", 
  #"chocolate" , "fire", "white", "bride", "woman", 
  #"summer"
]

datasets = {
  d1: 'u1',
  d2: 'u2',
  d3: 'u3',
  d4: 'u4',
  d5: 'u5'
}

queries.each do |q|
  AR::Log.head('Query:',q)
  o = {
    dataset: '/movielens/movielens-1mm/ratings.dat',
    testset: '/movielens/movielens-1mm/ratings.dat',
    query: q,
    ir_w: 1.0,
    number_of_results: 20,
    userid: 11
  }
  rs = AR.recommenders(o)
  ranker = AR.ranker(rs,o)
  ev = AR.evaluate(ranker, o)
  puts
  puts "IR:"
  pp ev.first
  puts
  puts "Stack:"
  pp ev[1]
  puts
  puts "Combined:"
  pp ev.last
  puts
end







