class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]

  # GET /chapters/1
  # GET /chapters/1.json
  def show
    ClickLog.click params.merge({ref_obj: @chapter})
    ClickLog.click params.merge({ref_obj: @book})
    ReadChapterHistory.add_to_history params.merge({chapter: @chapter})
    @pre_chapter,@current_chapter,@next_chapter = ReadBookHistory.reading_chapters params.merge({ref_obj: @book})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      m = params[:m]

      @chapter = Chapter.where(id: params[:id]).includes(:book,:content).first
      unless m.blank?
        @chapter = @chapter.send m.to_sym
      end
      if @chapter.present?
        @book = @chapter.book
        @category_id = @book.category_id
      end
    end
end
