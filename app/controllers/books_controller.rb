class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.search params.merge(page: @page)
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @chapters = @book.chapters
    ClickLog.click params.merge({ref_obj: @book})
    @pre_chapter,@current_chapter,@next_chapter = ReadBookHistory.reading_chapters params.merge({ref_obj: @book})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.where(id: params[:id]).includes(:category).first
      @category_id = @book.category_id
    end
end
