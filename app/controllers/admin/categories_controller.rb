class Admin::CategoriesController < AdminController

  def show
    @category = Category.find(params[:id])

    @posts = current_user.posts.where(category: @category)
  end

end
