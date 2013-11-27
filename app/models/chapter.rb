class Chapter < ActiveRecord::Base
  belongs_to :book
  belongs_to :volume
  has_one :content

  after_save :save_chapter_id

  def save_chapter_id
    c = ChapterId.find_by id: self.id

    config = {id: self.id,status: self.status}
    if c.nil?
      ChapterId.create config
    else
      c.update_attributes config
    end
  end

  def next
    Chapter.find next_id unless next_id.blank?
  end  

  def pre
    Chapter.find pre_id unless pre_id.blank?
  end
end