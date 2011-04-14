# Require Lucene jars and dependencies
Dir[File.join(File.dirname(__FILE__),'lucene','**','*.jar')].each do |jar|
  require jar
end

module MetaModel
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
  
  # https://github.com/davidx/jruby-lucene
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
      existing = Term.new('id', id.to_s) # if it exists
      document = Document.new
      document.add(field('text',text))
      document.add(field('id',id))
      w = index_writer
      w.update_document(existing, document)
      w.close
    end

    def query(text)
      parser = QueryParser.new(version, 'text', analyzer)
      parsed = parser.parse(text)
      engine = IndexSearcher.new(dir)
      scores = engine.search(parsed,10).scoreDocs
      results = []
      scores.each do |score|
        results << [score.score, to_s(engine.doc(score.doc))]
      end
      engine.close
      results
    end

    def to_s(doc)
      {
        id: doc.get_field('id').string_value.to_i,
        text: doc.get_field('text').string_value
      }
    end

  end

end
end
