class ReadChapterHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  belongs_to :chapter

  class<<self
    def add_to_history config
      chapter = config[:chapter]
      chapter_id = chapter.try(:id)
      book_id = chapter.try :book_id
      ReadChapterHistory.create! user_id: config[:user_id],book_id: book_id,chapter_id: chapter_id

      book_history = ReadBookHistory.find_by user_id: config[:user_id],book_id: book_id
      
      if book_history.nil?
        ReadBookHistory.create! user_id: config[:user_id],book_id: book_id,current_chapter_id: chapter_id
      else
        book_history.update_attributes! current_chapter_id: chapter_id,view_count: (book_history.view_count||0)+1
      end
    end
  end
end
