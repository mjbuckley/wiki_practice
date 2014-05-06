require 'spec_helper'

describe "Review pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "review creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a review" do
        expect { click_button "Submit review" }.not_to change(Review, :count)
      end

      describe "error messages" do
        before { click_button "Submit review" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      # this before block bellow may not be correct

      before do
        fill_in 'Rating', with: 2
        fill_in 'Page ID', with: 333
        fill_in 'Revision ID', with: 333444
        fill_in 'Compose a new review', with: "Lorem ipsum"
        fill_in 'Wikipedia page title', with: "page title"
      end

      it "should create a review" do
        expect { click_button "Submit review" }.to change(Review, :count).by(1)
      end
    end
  end

  # I altered the following test.  I checks for delete to work on the user's show
  # page rather than the root_path, because I don't have reviews showing up there
  # right now.  It seems to correctly ensure the delete link works, but I'm not
  # sure if I'm following correct rspec procedures.  Does the subject page at top
  # imply a particular page?  Does it matter that everything else on this page is
  #testing the root_path and this doesn't?  Not sure but keep it in mind.

  describe "review destruction" do
    before { FactoryGirl.create(:review, user: user) }

    describe "as correct user" do
      before { visit user_path(user) }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Review, :count).by(-1)
      end
    end
  end
end