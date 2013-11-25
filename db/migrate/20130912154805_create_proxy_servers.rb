class CreateProxyServers < ActiveRecord::Migration
  def change
    create_table :proxy_servers do |t|
      t.boolean :active
      t.string :ip
      t.string :port
      t.string :status
      t.integer :count
      t.integer :succ_count
      t.integer :error_count

      t.timestamps
    end
  end
end
