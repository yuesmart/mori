#encoding: utf-8
$:.unshift(File.dirname(__FILE__))

require 'mori'

class Ranwen
  include Mori
  BASE_URL = "http://www.ranwen.net"
  
  #解析图书
  #
  def parse_book page=1
    url = "#{BASE_URL}/modules/article/index.php?page=#{page}"
    doc = h url,ENCODING
    _parse_book doc
  end
  
  #解析章节
  #
  def parse_chapter
    Book.where(chapter_status: 'Pending').each do |book|
      _parse_chapter book
    end
  end
  
  #解析更新
  #
  def parse_update
    @updated_books_count = 0
    _parse_update
  end
  
  
  #解析书籍上下级关系
  #
  def parse_chapter_associate
    Book.all.each do |book|
      log book.name
      _parse_chapter_associate book.chapters
    end 
  end
  
  #解析书籍内容
  #
  def parse_content chapters = nil,_page=nil,_max_page=nil
    log "parse content:#{_page},#{_max_page}"
    max_page = _max_page.to_i
    
    if chapters.nil?
      page = ( _page || 1).to_i
      loop do
        log "parse content:#{page}"
        check_mysql_connection
        ids = ChapterId.select('id').page(page).per(PER_PAGE)
        chapters = Chapter.find ids.collect(&:id)
        log "size:#{chapters.size}"
        break if chapters.nil? || chapters.empty?
        _parse_content chapters
        break if max_page > 0 && page > max_page
        page+= 1
      end
    else
      _parse_content chapters
    end
  end
  
  def _parse_chapter_associate chapters
    chapters.each do |c|
      next if c.pre_id.blank?
      
      pre_chapter = c.pre
      next if pre_chapter.nil?
      
      pre_chapter.update_attributes next_id: c.id
    end
  end

  def _parse_content chapters
    log "parse content"
    threads = []
    chapter_ids = []
    chapters.each do |chapter|
      next if chapter.status=='Done'
      # threads<< Thread.new(c) do |chapter|
          begin
            log "\t#{chapter.name}"
            doc = h chapter.url,ENCODING
            html  = (doc/"#content").inner_html
            begin
              html = html.sub """\r\n\r\n<div align=\"center\"><script src=\"/ssi/style-gg.js\" type=\"text/javascript\"></script></div> \r\n\t\t\t""",""
              html = html.sub "\r\n\t\t\t",''
            rescue => e
              log e
            end
          
            Content.create content: html,book_id: chapter.book_id,chapter_id: chapter.id,word_count: content_count(html)
          
            if chapter.name.blank?
              title = t doc/"h1.bname_content"
              title = $1 if title =~ /《.*》\s*(.*?)/
              if (title||'') != chapter.name
                chapter.update_attributes status: 'Done',name: title
              else
                chapter_ids << chapter.id
              end
            else
              chapter_ids << chapter.id
              # chapter.update_attributes status: 'Done'
            end
            
            
          rescue => e
            log e
            #reset_mysql_connection if e.to_s =~ /could not obtain a database connection within/
            #chapter.update_attributes status: 'Error'
          end
      # end #end threads
    end #end each
    if chapter_ids.size>0
      Chapter.where(id: chapter_ids).update_all status: 'Done' 
      ChapterId.where(id: chapter_ids).delete_all 
    end
    # sleep(5)
  rescue => e
    log "error:#{e.inspect}"
  end

  
  def _parse_chapter book
    log "parse chapter"
    doc = h book.chapter_url,ENCODING
    book_info = doc/"#container_bookinfo"
    parent_chapter = Chapter.new
    (book_info/"tr/td/div.dccss/a").each do |a|
      begin
        _url,_text = la a

        url = book.chapter_url.sub('index.html',_url)
      
        config = {book_id: book.id,name: _text,url: url,pre_id: parent_chapter.id}
        chapter = Chapter.find_by url: url
        log "\t#{_text}"
        if chapter.nil?
          chapter = Chapter.create 
        end
        
        chapter.update_attributes config
        ChapterId.create id: chapter.id if ChapterId.find_by(id: chapter.id).nil?
        
        parent_chapter = chapter
      rescue => e
        log e
        ErrorUrl.create url: url, status: "book:#{book.id},parent:#{parent_chapter.id}"
      end
    end
    
    book.update_attributes chapter_status: 'Done'
  end
  

  def _parse_update page=1
    url = "#{BASE_URL}/modules/article/toplist.php?sort=lastupdate&page=#{page}"
    doc = h url,ENCODING
    _parse_book doc
  end
  


  def _parse_book doc
    log "parse book"
    updated_status = false
    (doc/"table.sf-grid/tbody/tr").each do |tr|
      begin
        td = tr/"td"
        category = td[0]
        name  = td[1]
        last_chapter = td[2]
        author = td[3]
        chapter_url = td[4]
        status = td[5]
      
        category_name = t category
        category_name = $1 if  category_name =~ /\[(.*?)\]/
      
        book_url,book_name = la name/"a"
      
        last_chapter_url,last_chapter_name = la last_chapter/"a"
     
        author = t author
      
        chapter_url,chapter_name = la chapter_url/"a"
      
        status = t status
      
        category = Category.find_by_name category_name
        category = Category.create(name: category_name) if category.nil?
      
        book = Book.find_by_url book_url
        
        config = {name: book_name,url: book_url,category_id: category.id,author: author,book_status: status,last_chapter_url: last_chapter_url,
          last_chapter_name: last_chapter_name,chapter_url: chapter_url,last_updated_at: Time.now}
        
        if book.nil?
          log "\tCreate book:#{book_name}"
          book = Book.create config
          _parse_chapter book
          parse_content book.chapters.where(status: 'Pending')
          _parse_chapter_associate book.chapters
        else
          if book.last_chapter_url == last_chapter_url
            log "\tBook #{book_name} not updated,next"
            @updated_books_count = @updated_books_count.blank? ? 1 : @updated_books_count + 1
            
            updated_status = true if @updated_books_count > MAX_UPDATED_COUNT
            break
          else
            log "\tUpdate book:#{book_name}"
            book.update_attributes config
            _parse_chapter book
            parse_content book.chapters.where(status: 'Pending')
            _parse_chapter_associate book.chapters
          end
        end
      rescue => e
        log e.inspect
      end
    end
    
    return if updated_status
    
    pagelink = doc/"#pagelink"
    next_page = pagelink/"a.next"
    
    if next_page.nil? || next_page.empty? || next_page.first.nil?
      
    else
      _url,_text = la next_page
      parse_book $1 if _url =~ /page=(\d+)$/
    end
  end
end