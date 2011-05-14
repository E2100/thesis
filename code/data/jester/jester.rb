require 'csv'
require 'pp'

def to_user_hash(data)
  u = 0
  users = {}
  data.lines.each do |line|
    #return users if u > 10
    u = u+1
    i = 0
    users[u] = {}
    ratings = line.split(',').map { |x| x.to_f }
    ratings.each do |r|
      i = i+1
      next if r == 99.0
      users[u][i] = (((r+10.0) / 20.0) * 4.0) + 1.0 # 1-5
      #users[u][i] = (r+10.0) / 20.0 # 0-1
      #users[u][i] = r # -10 - 10
      #users[u][i] = r + 10.0 + 1.0 # 1-21
    end
  end
  users
end

def part(h,percent)
  p1 = {}
  p2 = {}
  h.each do |u,i|
    p1[u] = {}
    p2[u] = {}
    is = h[u].to_a.shuffle
    x = (percent * is.size).to_i
    i1 = is[0,x].shuffle
    i2 = is[x,is.size-x].shuffle
    i1.each { |a| p1[u][a[0]] = a[1] }
    i2.each { |a| p2[u][a[0]] = a[1] }
  end
  return [p1,p2]
end

def to_rows(h)
  rows = []
  h.each do |user,items|
    items.each do |item,rating|
      rows << [user,item,rating]
    end
  end
  rows.shuffle
end

def pname(p)
  p.to_s.split('.').last
end

def filename(p)
  File.join('base',p,'jester')
end

def write(a,fp)
  CSV.open(fp, "wb") do |csv|
    a.each do |row|
      csv << row
    end
  end
end


data = File.open('jester.csv', 'rb').read
puts "loaded"
users = to_user_hash(data)
puts "hashed"

p1 = part(users,0.8);        
d1 = p1.last
puts "p1 done"

p2 = part(p1.first,0.75);    
d2 = p2.last
puts "p2 done"

p3 = part(p2.first,0.66);    
d3 = p3.last
puts "p3 done"

p4 = part(p3.first,0.50);    
d4 = p4.last
d5 = p4.first
puts "p4 done"

puts d1.size
puts d2.size
puts d3.size
puts d4.size
puts d5.size

puts "total: #{users.size}"
puts "parts: #{users.size / 5}"

s1 = part(d1,0.8); b1 = s1.first; t1 = s1.last; puts "s1 done"
s2 = part(d2,0.8); b2 = s2.first; t2 = s2.last; puts "s2 done"
s3 = part(d3,0.8); b3 = s3.first; t3 = s3.last; puts "s3 done"
s4 = part(d4,0.8); b4 = s4.first; t4 = s4.last; puts "s4 done"
s5 = part(d5,0.8); b5 = s5.first; t5 = s5.last; puts "s5 done"

puts "writing bases"
write(to_rows(b1), 'splits/base/1'); puts " 1"
write(to_rows(b2), 'splits/base/2'); puts " 2"
write(to_rows(b3), 'splits/base/3'); puts " 3"
write(to_rows(b4), 'splits/base/4'); puts " 4"
write(to_rows(b5), 'splits/base/5'); puts " 5"

puts "writings tests"
write(to_rows(t1), 'splits/test/1'); puts " 1"
write(to_rows(t2), 'splits/test/2'); puts " 2"
write(to_rows(t3), 'splits/test/3'); puts " 3"
write(to_rows(t4), 'splits/test/4'); puts " 4"
write(to_rows(t5), 'splits/test/5'); puts " 5"






