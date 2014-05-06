class ReviewsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  # Deleted index, new, and update for now but they should be added later.
  # Update should be added to the before action, but not index.  New probably should
  # be in the before action too, but not certain.
  # Also, eventually need to find a way to not ask for rev or page id and to find them
  # in the background from just the tilte info.  But I just want to get this working for now.
  # Perhaps a before save method would need to be used to do this?  Not sure.

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "Review created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @review.destroy
    redirect_to root_url
  end

  private

    def review_params
      params.require(:review).permit(:rating, :page_id, :rev_id, :comment, :title)
    end

    def correct_user
      @review = current_user.reviews.find_by(id: params[:id])
      redirect_to root_url if @review.nil?
    end
end
