class ChapterId < ActiveRecord::Base
  self.primary_key= 'id'
  attr_accessible *column_names
end
