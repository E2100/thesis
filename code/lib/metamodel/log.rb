module AR
module Log
  extend self
  
  def out(*msg)
    puts timestamp + msg.join(' ')
  end
  
  def task(t)
    puts
    puts timestamp + "Task | #{t[:mission].to_s.capitalize}: #{t[t[:mission]]}"
    puts '-'*100
    puts t.opts.select { |k,v| not [:recommenders].include?(k) }.to_s
    puts
  end

  def head(*msg)
    puts
    puts msg.join(' ')
    puts '-'*100
  end

  def evaluation(x)
    puts timestamp + "Evaluation results:"
    pp x.sort { |a,b| a.last <=> b.last }
    puts
  end

  def hits(hs)
    hs.each_with_index do |h,i|
      score = h.first
      doc   = h.last
      title = Lucene::API.new.get(doc[:id])[:text]
      puts "#{i}: #{doc[:id]} - #{title} (#{score})"
    end
  end
  
  def timestamp
    Time.now.strftime("[%T] ")
  end

end
end
