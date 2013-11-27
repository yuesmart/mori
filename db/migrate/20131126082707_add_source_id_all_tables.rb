class AddSourceIdAllTables < ActiveRecord::Migration
  def change
    add_column :volumes,:source_id,:integer,index: true
    add_column :categories,:source_id,:integer,index: true
    add_column :chapters,:source_id,:integer,index: true
    add_column :contents,:source_id,:integer,index: true

    add_column :chapter_ids,:source_id,:integer,index: true
    add_column :error_urls,:source_id,:integer,index: true

    add_column :click_logs,:source_id,:integer,index: true
    add_column :favourites,:source_id,:integer,index: true
    add_column :read_book_histories,:source_id,:integer,index: true
    add_column :read_chapter_histories,:source_id,:integer,index: true
  end
end
