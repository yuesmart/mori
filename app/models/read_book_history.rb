class ReadBookHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  belongs_to :current_chapter,class_name: 'Chapter',foreign_key: 'current_chapter_id'

  class<<self
    def histories config
      self.where(user_id: config[:user_id]).includes(:book,:current_chapter).order(updated_at: :desc).page(@page)
    end

    def reading_chapters config
      book = config[:ref_obj]
      return nil,nil,nil if book.nil?
      book_id = book.try(:id)
      book_history = ReadBookHistory.find_by user_id: config[:user_id],book_id: book_id
      if book_history.nil?
        return nil,nil,nil
      else
        current_chapter = book_history.current_chapter
        if current_chapter.present?
          next_chapter = current_chapter.next
          pre_chapter = current_chapter.pre
          return pre_chapter,current_chapter,next_chapter
        else
          return nil,nil,nil
        end
      end
    end
  end
end
