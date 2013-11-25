class CreateReadChapterHistories < ActiveRecord::Migration
  def change
    create_table :read_chapter_histories do |t|
      t.references :user, index: true
      t.references :book, index: true
      t.references :chapter, index: true

      t.timestamps
    end
  end
end
