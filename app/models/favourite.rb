class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  class<<self
    def add config
      self.create user_id: config[:user_id],book_id: config[:book_id] if self.find_by(user_id: config[:user_id],book_id: config[:book_id]).nil?
    end
  end
end
