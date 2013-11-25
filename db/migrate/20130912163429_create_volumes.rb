class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.references :book, index: true
      t.string :name
      t.integer :parent_id
      t.integer :next_id
      t.string :code,index: true

      t.timestamps
    end
  end
end
