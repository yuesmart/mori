class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :code
      t.string :url
      t.string :crawler
      t.text :rules
      t.boolean :active,default: true
      t.timestamps
    end
  end
end