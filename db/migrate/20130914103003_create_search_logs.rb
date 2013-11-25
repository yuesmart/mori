class CreateSearchLogs < ActiveRecord::Migration
  def change
    create_table :search_logs do |t|
      t.references :user, index: true
      t.references :search_word, index: true
      t.string :q

      t.timestamps
    end
  end
end
