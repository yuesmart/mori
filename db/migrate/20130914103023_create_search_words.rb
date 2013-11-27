class CreateSearchWords < ActiveRecord::Migration
  def change
    create_table :search_words do |t|
      t.string :q, index: true
      t.integer :count,:integer,default: 0
      t.timestamps
    end
  end
end
