class CreateClickLogs < ActiveRecord::Migration
  def change
    create_table :click_logs do |t|
      t.references :user, index: true
      t.integer :ref_id
      t.string :ref_clazz
      t.string :ref_url

      t.timestamps
    end
  end
end
