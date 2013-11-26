#encoding: utf-8
$:.unshift(File.dirname(__FILE__))

require 'mori'

class Parse
  include Mori
  #解析图书
  #
  def parse_book page=1
    @config ||= YAML.load(Source.find_by(code: source_name).rules)
    _config = @config[:list]
    
    doc  = h _config[:url].sub(':page',page.to_s)
    list_books = doc/_config[:pattern]
    
    book_config = _config[:book]
    book_config[:pattern].split(',').each do |_p|
      _parse_book doc,_p,book_config
    end
  end
  
  def _parse_book doc,pattern,book_config
    (doc/pattern).each do |item|
      book_params = {}
      book_config[:segments].each do |key,value|
        if value.is_a?(Hash)
          type = value[:type]
          if type == 'href'
            _url,_name = la item/value[:pattern]
            
            book_params[get_key_name type,key,value,'url'] = _url if value[:save_url].nil? || value[:save_url] == true
            book_params[get_key_name type,key,value,'name'] = _name
          else
            raise "Error type:#{type}"
          end
        else
          book_params[key] = t item/value
        end
      end
      
       _save_book book_params
    end
  end

  #解析章节
  #
  def parse_chapter
  end
  
  #解析更新
  #
  def parse_update
  end
  
  #解析书籍内容
  #
  def parse_content chapters = nil
  end
  
  #解析书籍上下级关系
  #
  def parse_chapter_associate
  end

  #================================================================
  def _save_book book_params
    
  end
end