class Source < ActiveRecord::Base
  attr_accessible *column_names
end
