#encoding: utf-8
$:.unshift(File.dirname(__FILE__))

require 'mori'

class Ranwen
  include Mori

  BASE_URL = "http://www.ranwen.net"
  PER_PAGE = 25
  ENCODING = "gb2312"
  
  def parse_chapter_associate
    Book.all.each do |book|
      log book.name
      parse_chapter_associate_inner book.chapters
    end 
  end
  
  def parse_chapter_associate_inner chapters
    chapters.each do |c|
      next if c.pre_id.blank?
      
      pre_chapter = c.pre
      next if pre_chapter.nil?
      
      pre_chapter.update_attributes next_id: c.id
    end
  end
  
  def parse_special_book
    %w{21737}.each do |book_id|
      book = Book.find book_id
      log book.name
      parse_content book.chapters.where(status: 'Pending')
    end
  end
  
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
        parse_content_inner chapters
        break if max_page > 0 && page > max_page
        page+= 1
      end
    else
      parse_content_inner chapters
    end
  end

  def parse_content_inner chapters
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
  
  def check_mysql_connection
    # kids = Book.connection.execute "select count(id) count from information_schema.processlist where Command='Sleep' and db='mori_development' and Time>10"
    # 
    # count = kids.first.first
    # log '*'*100
    # log "current connection:#{count}"
    # log '*'*100
    reset_mysql_connection #if count.to_i > 50
  end
  
  def reset_mysql_connection
    kids = Book.connection.execute "select concat('KILL ',id) kid from information_schema.processlist where  Command='Sleep' and db='mori_development' and Time>500"
    kids.each do |k|
      log "kill mysql connection:#{k.first}"
      begin
        Book.connection.execute k.first
      rescue => e
        log "killed error:#{e.inspect}"
      end
    end
    
    begin
      ActiveRecord::Base.clear_active_connections!
    rescue => e
      log "clear error:#{e.inspect}"
    end
    # sleep 1
  end
    
  def content_count html
    trim(html).length rescue 0
  end
  
  def parse_chapter
    Book.where(chapter_status: 'Pending').each do |book|
      parse_chapter_info book
    end
  end
  
  def parse_chapter_info book
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
  
  def parse_book_update
    @updated_books_count = 0
    parse_book_update_inner
  end
  
  def parse_book_update_inner page=1
    url = "#{BASE_URL}/modules/article/toplist.php?sort=lastupdate&page=#{page}"
    doc = h url,ENCODING
    parse_book_info doc
  end
  
  def parse_book
    parse_book_inner
  end
  
  def parse_book_inner page=1
    url = "#{BASE_URL}/modules/article/index.php?page=#{page}"
    doc = h url,ENCODING
    parse_book_info doc
  end

  def parse_book_info doc
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
          parse_chapter_info book
          parse_content book.chapters.where(status: 'Pending')
          parse_chapter_associate_inner book.chapters
        else
          if book.last_chapter_url == last_chapter_url
            log "\tBook #{book_name} not updated,next"
            @updated_books_count += 1
            updated_status = true if @updated_books_count > 100
            break
          else
            log "\tUpdate book:#{book_name}"
            book.update_attributes config
            parse_chapter_info book
            parse_content book.chapters.where(status: 'Pending')
            parse_chapter_associate_inner book.chapters
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
      parse_book_inner $1 if _url =~ /page=(\d+)$/
    end
  end
end