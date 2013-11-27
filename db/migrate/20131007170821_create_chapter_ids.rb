class CreateChapterIds < ActiveRecord::Migration
  def change
    create_table :chapter_ids,id: false do |t|
      t.integer :id
      t.string :status,length: 8,default: 'Pending'
    end
    
  end
end
