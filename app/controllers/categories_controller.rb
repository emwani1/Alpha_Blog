class CategoriesController < ApplicationController
  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new(category_params)
    if @category.save
      flash[:sucess] = "Category was successully created"
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])

  end

  def update
    @category = Category.find(params[:id])
    if @category.update
      flash[:sucess] = "Category was successully updated"
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy

  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin

    if !logged_in? || (logged_in? and !current_user.admin?)

      flash[:danger] = "Only admins can perform that action"

      redirect_to categories_path

    end
  end

end

