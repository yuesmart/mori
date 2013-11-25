class Content < ActiveRecord::Base
  belongs_to :book
  belongs_to :chapter
  belongs_to :volume
end
