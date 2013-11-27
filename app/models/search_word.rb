class SearchWord < ActiveRecord::Base
  attr_accessible *column_names
  belongs_to :user
end
