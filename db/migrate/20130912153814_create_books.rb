class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.string :code
      t.string :author
      t.string :last_updated_at
      t.references :source, index: true
      t.integer :view_count,default: 0
      t.string :desc
      t.boolean :recommend,default: false
      t.boolean :hot,default: false
      t.integer :word_count,default: 0
      t.integer :comment_count,default: 0
      t.timestamp :deleted_at
      t.boolean :deleted,default: false
      t.references :last_chapter,index: true
      t.string :status
      t.references :category,index: true

      t.timestamps
    end
  end
end
