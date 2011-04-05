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
      users[u][i] = (r+10.0) / 20.0 
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
users = to_user_hash(data)

parts = part(users,0.5)
parts1 = part(parts[0],0.5)
parts2 = part(parts[1],0.5)

u1 = parts1[0]
u2 = parts1[1]
u3 = parts2[0]
u4 = parts2[1]

parts = [u1,u2,u3,u4]
names = [:u1,:u2,:u3,:u4]

parts.each_with_index do |u,i|
  parts = part(u,0.8)
  main  = parts[0]
  test  = parts[1]
  parts = part(main,0.6)
  base  = parts[0]
  meta  = parts[1]
  
  pp test.size
  pp base.size
  pp meta.size

  test = to_rows(test)
  base = to_rows(base)
  meta = to_rows(meta)
  
  write(test, '20/' + names[i].to_s)
  write(base, '50/' + names[i].to_s)
  write(meta, '30/' + names[i].to_s)

end

