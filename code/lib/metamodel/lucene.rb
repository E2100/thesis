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

  class API
    
    def initialize(path='data/ir/')
      @path = path
    end
   
    def dir
      @dir ||= SimpleFSDirectory.new(java.io.File.new(@path))
    end

    def index_available
      @available ||= IndexReader.index_exists(dir)
    end
    
    def index_writer_config
      IndexWriterConfig.new(Version::LUCENE_31, StandardAnalyzer.new(Version::LUCENE_31))
    end

    def index_writer
      @writer ||= IndexWriter.new(dir, index_writer_config)
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
      index_writer.update_document(existing, document)
      #index_writer.close
    end

  end


  # https://github.com/davidx/jruby-lucene
  class Lucene2
    @index_path = nil
    
    def initialize(an_index_path = "data/")
      @index_path = an_index_path
    end
    
    def add_documents(id_text_pair_array) # e.g., [[1,"test1"],[2,'test2']]
      index_available = org.apache.lucene.index.IndexReader.index_exists(@index_path)
      index_writer = org.apache.lucene.index.IndexWriter.new(
            @index_path,
            org.apache.lucene.analysis.standard.StandardAnalyzer.new,
            !index_available)
      id_text_pair_array.each {|id_text_pair|
        term_to_delete = org.apache.lucene.index.Term.new("id", id_text_pair[0].to_s) # if it exists
        a_document = org.apache.lucene.document.Document.new
        a_document.add(org.apache.lucene.document.Field.new('text', id_text_pair[1],
                         org.apache.lucene.document.Field::Store::YES,
                         org.apache.lucene.document.Field::Index::TOKENIZED))
        a_document.add(org.apache.lucene.document.Field.new('id', id_text_pair[0].to_s,
                         org.apache.lucene.document.Field::Store::YES,
                         org.apache.lucene.document.Field::Index::TOKENIZED))
        index_writer.updateDocument(term_to_delete, a_document) # delete any old docs with same id
      }
      index_writer.close
    end
    
    def search(query)
      parse_query = org.apache.lucene.queryParser.QueryParser.new(
           'text',
           org.apache.lucene.analysis.standard.StandardAnalyzer.new)
      query = parse_query.parse(query)
      engine = org.apache.lucene.search.IndexSearcher.new(@index_path)
      hits = engine.search(query).iterator
      results = []
      while (hits.hasNext && hit = hits.next)
        id = hit.getDocument.getField("id").stringValue.to_i
        text = hit.getDocument.getField("text").stringValue
        results << [hit.getScore, id, text]
      end
      engine.close
      results
    end
    
    def delete_documents id_array # e.g., [1,5,88]
      index_available = org.apache.lucene.index.IndexReader.index_exists(@index_path)
      index_writer = org.apache.lucene.index.IndexWriter.new(
            @index_path,
            org.apache.lucene.analysis.standard.StandardAnalyzer.new,
            !index_available)
      id_array.each {|id|
        index_writer.deleteDocuments(org.apache.lucene.index.Term.new("id", id.to_s))
      }
      index_writer.close
    end

  end

end
end
