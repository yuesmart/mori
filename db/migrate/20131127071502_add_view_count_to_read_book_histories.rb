class AddViewCountToReadBookHistories < ActiveRecord::Migration
  def change
    add_column :read_book_histories, :view_count, :integer,default: 0 unless ReadBookHistory.new.respond_to?(:view_count)
  end
end
