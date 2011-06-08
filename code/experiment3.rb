require 'experiments'

# Select the query to use for the experiment
# Good examples for this dataset include:
#   
#  "new york", "washington", "paris", "star trek",
#  "man", "life", "day", "star", "time", "night", 
#  "paris", "city", "death", "boys", "king", "story", 
#  "home", "movie", "american", "sea", "world", "fear", 
#  "girl", "house", "secret", "bad", "family", "america", 
#  "chocolate" , "fire", "white", "bride", "woman"
#
query = "paris"

# Select a user to run the query for (ids 1-943)
user = 11

# Create settings based on our settings
settings = {
  dataset: '/movielens/movielens-1mm/ratings.dat',
  testset: '/movielens/movielens-1mm/ratings.dat',
  query: query,
  ir_w: 1.0,
  number_of_results: 20,
  userid: 11
}

# Create the recommenders
rs = AR.recommenders(settings)

# Create the adaptive rank aggregator
ar = AR.ranker(rs, settings)

# Create a rank evaluator
ev = AR.evaluate(ar, settings)

# Print out the resulting rankings
AR::Log.head('Query:', query)
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

