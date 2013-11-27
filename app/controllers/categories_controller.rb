class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category_id = params[:id]
    @category = Category.find @category_id
    @books = @category.books.order(content_active: :desc,updated_at: :desc).page(@page)
    ClickLog.click params.merge({ref_obj: @category})
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end
end
