class ReviewsController < ApplicationController
  require 'open-uri'
  #not sure if this is required in the right place, but it works.
  before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: :destroy

  # Need to add an update action at some point, also add that to before actions

  # This works, but probably not a good way to do things once review numbers get large.  Also, paginate.
  def index
    @reviews = Review.all.order(created_at: :desc)
  end

  # This is working, but should I have @review = current_user.reviews.build instead?
  def new
    @review = Review.new
  end

  def show
    @review = Review.find(params[:id])
  end

  def create
  # I should definately make this more compact, but this works for now.  Perhaps case statements would be nicer.
    @review = current_user.reviews.build(review_params)
    @user = current_user

    if @review.rev_id.blank? && !@review.title.blank?
    # With no given rev_id (user wants current version), and with a non-blank title
      page_title = @review.title.gsub(' ', '%20')
      response = open("http://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{page_title}&prop=info").read
      parsed_response = JSON.parse(response)
      pre_page_id = parsed_response["query"]["pages"].keys
      page_id = pre_page_id[0]
      # Returns a string no an integer.  Need to keep as string to access it in hash, but convert before save and when
      # treating as an integer.
      if page_id.to_i == -1
      # Will return -1 if a non-existent title was given
        flash.now[:error] = 'The title you entered does not exist.  Please recheck the title.'
        render new_review_path
      else
        rev_id = parsed_response["query"]["pages"][page_id]["lastrevid"].to_i
        @review.page_id = page_id.to_i
        @review.rev_id = rev_id

        if @review.save
          unless Article.exists? page_id: @review.page_id
            Article.create(page_id: @review.page_id, title: @review.title)
          end
          flash[:success] = "Review created!"
          redirect_to user_path(@user)
        else
          render new_review_path
        end
      end
    elsif !@review.rev_id.blank? && !@review.title.blank?
    # With a non-blank rev_id and title
      rev_id = @review.rev_id
      response = open("http://en.wikipedia.org/w/api.php?action=query&revids=#{rev_id}&format=json").read
      parsed_response = JSON.parse(response)
      if parsed_response["query"].keys[0] == "pages"
      # This makes sure that the given rev_id is a valid id that points to a real page.
      # If a non-existent rev_id is given, the second nested key will be "badrevids" instead of "pages."
        pre_page_id = parsed_response["query"]["pages"].keys
        page_id = pre_page_id[0].to_i
        real_title = parsed_response["query"]["pages"][page_id.to_s]["title"]
        if @review.title == real_title
        # Makes sure that the given title matches the title associated with the given rev_id
          @review.page_id = page_id

          if @review.save
            unless Article.exists? page_id: @review.page_id
              Article.create(page_id: @review.page_id, title: @review.title)
            end
            flash[:success] = "Review created!"
            redirect_to user_path(@user)
          else
            render new_review_path
          end
        else
          flash.now[:error] = 'The title does not match the rev_id.  Please recheck your information.'
          render new_review_path
        end
      else
        # return an error telling user they have entered a non-existent rev_id.
        flash.now[:error] = 'The rev_id does not exist.  Please recheck your information.'
        render new_review_path
      end
    else
      # User has entered a blank title.  I probably could have let the model validations catch this, but
      # I'm not sure how nil would get passed to the wikipedia api, and
      # I want to be sure that nil didn't somehow become part of the page title.
      flash.now[:error] = 'The title cannot be blank.  Please enter a title for your review.'
      render new_review_path
    end
  end

  # consider replacing the given title with the wikipedia corrected title.  This would correct any capitalization errors?


  def destroy
    @review.destroy
    redirect_to root_url
  end

  private

    def review_params
      params.require(:review).permit(:rating, :rev_id, :comment, :title)
    end

    def correct_user
      @review = current_user.reviews.find_by(id: params[:id])
      redirect_to root_url if @review.nil?
    end
end
