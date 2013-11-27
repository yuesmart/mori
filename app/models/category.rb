class Category < ActiveRecord::Base
  attr_accessible *column_names
  has_many :books

end