class AddExtColumnsToChapters < ActiveRecord::Migration
  def change
    rename_column :chapters,:parent_id,:pre_id if Chapter.new.respond_to?(:parent_id)
  end
end
