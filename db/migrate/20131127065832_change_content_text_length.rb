class ChangeContentTextLength < ActiveRecord::Migration
  def change
    change_column :contents,:content,:text,limit: 4294967295
  end
end
