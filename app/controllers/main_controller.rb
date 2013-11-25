class MainController < ApplicationController
  def index
    @histories = ReadBookHistory.histories params.merge({page: @page})
    @hot_books = Book.hot
    @recent_books = Book.recent
  end
end