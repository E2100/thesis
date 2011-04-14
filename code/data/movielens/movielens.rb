require 'csv'
require 'pp'

files = [
  "movielens-100k/base/100/u0.base",
  "movielens-100k/base/100/u1.base",
  "movielens-100k/base/100/u2.base",
  "movielens-100k/base/100/u3.base",
  "movielens-100k/base/100/u4.base",
  "movielens-100k/base/100/u5.base",
]

p = 0.6

def to_user_hash(data)
  users = {}
  data.each do |row|
    u = row[0]
    i = row[1]
    r = row[2]
    users[u] = {} unless users.key?(u)
    users[u][i] = r
  end
  users
end

def part(h,percent)
  p1 = {}
  p2 = {}
  h.each do |u,i|
    p1[u] = {}
    p2[u] = {}
    is = h[u].to_a
    x = (percent * is.size).to_i
    i1 = is[0,x]
    i2 = is[x,is.size-x]
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
  rows
end

def pname(fp,p)
  (p * 100).to_i.to_s
end

def filename(fp, p)
  base = fp.split('/')[0,2].join('/')
  file = fp.split('/').last
  per = pname(fp,p)

  File.join(base, per, file + '.' + per)
end

def write(a,fp)
  CSV.open(fp, "wb") do |csv|
    a.each do |row|
      csv << row
    end
  end
end

#files.each do |fp|
#  puts fp
#  data = CSV.read(fp)
#  size = data.size 
#  users = to_user_hash(data)
#  parts = part(users,p)
#  r1 = to_rows(parts[0])
#  r2 = to_rows(parts[1])
#  f1 = filename(fp, p)
#  f2 = filename(fp, 1-p)
#  write(r1, f1)
#  write(r2, f2)
#end

file = 'movielens-100k/meta/u.data'
p = 0.6

data = CSV.read(file)
users = to_user_hash(data)
parts = part(users,p)
r1 = to_rows(parts[0])
r2 = to_rows(parts[1])
write(r1, 'movielens-100k/base/60/u.data')
write(r2, 'movielens-100k/base/40/u.data')


