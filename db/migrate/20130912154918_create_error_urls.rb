class CreateErrorUrls < ActiveRecord::Migration
  def change
    create_table :error_urls do |t|
      t.string :url
      t.string :status
      t.boolean :active

      t.timestamps
    end
  end
end
