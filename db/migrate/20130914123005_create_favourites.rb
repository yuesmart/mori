class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.references :user, index: true
      t.references :book, index: true
      t.timestamp :deleted_at
      t.boolean :deleted,default: false

      t.timestamps
    end
  end
end
