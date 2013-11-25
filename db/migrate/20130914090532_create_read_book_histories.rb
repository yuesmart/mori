class CreateReadBookHistories < ActiveRecord::Migration
  def change
    create_table :read_book_histories do |t|
      t.references :user, index: true
      t.references :book, index: true
      t.integer :current_chapter_id

      t.timestamps
    end
  end
end
