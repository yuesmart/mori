#encoding: utf-8
$:.unshift(File.dirname(__FILE__))

require 'mori'

class Parse
  include Mori
  def load_source
    @source = Source.find_by(code: source_name)
    @config ||= YAML.load(@source.rules)
  end

  #解析图书
  #
  def parse_book page=1
    log "parse book page:#{page}"
    load_source
    _config = @config[:book][:list]
    doc = h _config[:url].sub(':page', page.to_s)
    book = doc/_config[:path]
    book_config = _config[:item]

    count = 0
    book_config[:path].split(',').each do |_p|
      count += _parse_book book, _p, book_config
    end

    return if count < 1

    page_number = -1
    _paging = _config[:paging]
    if _paging
      page = doc/_paging[:path]
      if _paging[:current_page].present?
        page_number =(t page/_paging[:current_page]).to_i
        page_number += 1
      elsif   _paging[:next_page].present?
        page_number = t page/_paging[:next_page]
      end
    end

    parse_book page_number if page_number>1
  end

  def parse_info
    load_source
    _config = @config[:book][:info]
    
    Book.all.each do |book|
      doc = h "#{@source.url}#{book.url}"
      info = doc/_config[:path]
      _parse_info info,book,_config
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
  def _parse_info doc,book,book_config
     item = doc
     book_params = {}
     book_config[:segments].each do |key, value|
       if value.is_a?(Hash)
         category = value[:category]||'string'
         if category == 'string'
           type = value[:type]||'text'
           if type == 'href'
             _url, _name = la item/value[:path]
             book_params[get_key_name type, key, value, 'url'] = _url if value[:save_url].nil? || value[:save_url] == true
             book_params[get_key_name type, key, value, 'name'] = _name
           else
             raise "Error type:#{type}"
           end
         elsif category == 'regexp'
           str = (item/value[:path]).inner_html
           book_params[key] = $1 if str =~ /#{value[:pattern]}/
         elsif category == 'replace'
           #ignore
         else
           raise "Error category:#{category}"
         end
       else
         book_params[key] = t item/value
       end
     end 
     
     p book_params
  end
  
  def _parse_book doc, path, book_config
    _count = 0
    (doc/path).each do |item|
      book_params = {}
      book_params[:source_id] = @source.id
      book_config[:segments].each do |key, value|
        if value.is_a?(Hash)
          category = value[:category]||'string'
          if category == 'string'
            type = value[:type]||'text'
            if type == 'href'
              _url, _name = la item/value[:path]
              book_params[get_key_name type, key, value, 'url'] = _url if value[:save_url].nil? || value[:save_url] == true
              book_params[get_key_name type, key, value, 'name'] = _name
            else
              raise "Error type:#{type}"
            end
          elsif category == 'regexp'
            str = (item/value[:path]).inner_html
            book_params[key] = $1 if str =~ /#{value[:pattern]}/
          else
            raise "Error category:#{category}"
          end
        else
          book_params[key] = t item/value
        end
      end
      
      _save_book book_params
      _count += 1
    end

    _count
  end
  
  def _save_book book_params
    book = Book.find_by(source_id: book_params[:source_id], url: book_params[:url])||Book.new

    book_params.each do |key, value|
      if book.respond_to?(key)
        book.send :write_attribute, key, value
      else
        log "*** invalid attribute:#{key}"
      end
    end

    log "#{book.id.present? ? 'Update' : 'Create'} #{book_params[:name]}"
    book.save
  end
end