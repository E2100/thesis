# Require Lucene jars and dependencies
Dir[File.join(File.dirname(__FILE__),'lucene','**','*.jar')].each do |jar|
  require jar
end

module AR
module Lucene
  
  import org.apache.lucene.util.Version
  import org.apache.lucene.store.Directory
  import org.apache.lucene.store.SimpleFSDirectory
  import org.apache.lucene.index.IndexReader
  import org.apache.lucene.index.IndexWriter
  import org.apache.lucene.index.IndexWriterConfig
  import org.apache.lucene.index.Term
  import org.apache.lucene.document.Document
  import org.apache.lucene.document.Field
  import org.apache.lucene.analysis.standard.StandardAnalyzer
  import org.apache.lucene.queryParser.QueryParser
  import org.apache.lucene.search.IndexSearcher
  
  class API
    
    def initialize(path='data/ir/')
      @path = path
    end
   
    def dir
      SimpleFSDirectory.new(java.io.File.new(@path))
    end

    def index_available
      IndexReader.index_exists(dir)
    end
    
    def index_writer_config
      IndexWriterConfig.new(version, analyzer)
    end
    
    def index_writer
      IndexWriter.new(dir, index_writer_config)
    end

    def version
      Version::LUCENE_31
    end

    def analyzer
      StandardAnalyzer.new(version)
    end

    def field(name, content)
      Field.new(
        name.to_s,
        content.to_s,
        Field::Store::YES,
        Field::Index::ANALYZED)
    end
    
    def add_document(id, text)
      Log.out('Indexing', id, text)
      existing = Term.new('id', id.to_s) # if it exists
      document = Document.new
      document.add(field('text',text))
      document.add(field('id',id))
      w = index_writer
      w.update_document(existing, document)
      w.close
    end

    def query(text, n=10)
      parser = QueryParser.new(version, 'text', analyzer)
      parsed = parser.parse(text)
      engine = IndexSearcher.new(dir)
      scores = engine.search(parsed,n).scoreDocs
      results = []
      scores.each do |score|
        results << [score.score, to_s(engine.doc(score.doc))]
      end
      engine.close
      results
    end

    def get(id)
      parser = QueryParser.new(version, 'id', analyzer)
      parsed = parser.parse(id.to_s)
      engine = IndexSearcher.new(dir)
      scores = engine.search(parsed,1).scoreDocs
      doc    = to_s(engine.doc(scores.first.doc))
      engine.close
      doc
    end

    def to_s(doc)
      {
        id: doc.get_field('id').string_value.to_i,
        text: doc.get_field('text').string_value
      }
    end
  
    def index_documents(task)
      Log.out('Reading CSV', task[:dataset])
      CSV.foreach(Config::Data + task[:dataset]) do |row|
        add_document(row[0].to_i, row[1].to_s)
      end
    end

    def serp(ids)
      ids.each_with_index do |id,i|
        puts "#{i}: #{id} - #{get(id)[:text]}"
      end
    end
  end

end
end
