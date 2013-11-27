class AddStatusToChapter < ActiveRecord::Migration
  def change
    add_column :chapters,:status,:string,limit: 12 unless Chapter.new.respond_to?(:status)
    execute "insert into chapter_ids(id,status) select id,status from chapters"
  end
end
