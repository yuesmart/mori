class Content < ActiveRecord::Base
  attr_accessible *column_names
  belongs_to :book
  belongs_to :chapter
  belongs_to :volume
end
