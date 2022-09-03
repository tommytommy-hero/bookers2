class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      @users = @users.page(params[:page])
    else
      @books = Book.looks(params[:search], params[:word])
      @books = @books.page(params[:page])
    end
  end

end
