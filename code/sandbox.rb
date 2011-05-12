require 'pp'

f = File.open('data/movielens/movielens-1mm/movies.dat').read

titles = f.split("\n").map do |line|
  line.gsub!(/[0-9]+,/,"")
  line.gsub(/ \([0-9]+\)/,"")
end

words = titles.join(' ').split(' ').map do |word|
  word.gsub(/\(|\)|-|[0-9]+/, "").downcase
end
words.delete_if { |w| w.size < 3 }

freqs = {}
words.each do |word|
  if freqs.key?(word)
    freqs[word] += 1
  else
    freqs[word] = 1
  end
end

s = freqs.sort { |a,b| b.last <=> a.last }

pp s.first(100)
