class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name,index: true
      t.integer :books_count

      t.timestamps
    end
  end
end
