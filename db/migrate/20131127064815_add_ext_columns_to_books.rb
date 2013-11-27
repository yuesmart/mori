class AddExtColumnsToBooks < ActiveRecord::Migration
  def change
    book = Book.new
    %w{url source_ref_id  last_chapter_url chapter_status last_chapter_name chapter_url book_status}.each do |c|
      add_column :books,c.to_sym,:string unless book.respond_to?(c.to_sym)
    end
    
    %w{chapters_count contents_count}.each do |c|
      add_column :books,c.to_sym,:integer unless book.respond_to?(c.to_sym)
    end
    
    add_column :books,:content_active,:boolean,default: false unless book.respond_to?(:content_active)
  end
end
