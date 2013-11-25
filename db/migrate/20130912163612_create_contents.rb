class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.references :book, index: true
      t.references :chapter, index: true
      t.references :volume, index: true
      t.text :content
      t.integer :word_count

      t.timestamps
    end
  end
end
