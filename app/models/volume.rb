class Volume < ActiveRecord::Base
  attr_accessible *column_names
  belongs_to :book
end
