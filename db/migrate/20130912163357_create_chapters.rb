class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.references :book, index: true
      t.string :name
      t.string :url,index: true
      t.timestamp :deleted_at
      t.string :deleted
      t.integer :parent_id
      t.integer :next_id
      t.references :volume, index: true
      t.string :code,index: true
      t.integer :view_count,:integer

      t.timestamps
    end
  end
end
