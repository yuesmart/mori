class AddExtColumnsToCategories < ActiveRecord::Migration
  def change
    add_column :categories,:view_count,:integer unless Category.new.respond_to?(:view_count)
  end
end
