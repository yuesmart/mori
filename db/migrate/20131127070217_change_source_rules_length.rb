class ChangeSourceRulesLength < ActiveRecord::Migration
  def change
    change_column :sources,:rules,:text,limit: 4294967295
  end
end
