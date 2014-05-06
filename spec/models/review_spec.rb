require 'spec_helper'

describe Review do

  let(:user) { FactoryGirl.create(:user) }
  before { @review = user.reviews.build(rating: 3, user_id: user.id, page_id: 23743, rev_id: 3847349827, comment: "I liked this article", title: "page title") }

  subject { @review }

  it { should respond_to(:rating) }
  it { should respond_to(:user_id) }
  it { should respond_to(:page_id) }
  it { should respond_to(:rev_id) }
  it { should respond_to(:comment) }
  it { should respond_to(:title) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @review.user_id = nil }
    it { should_not be_valid }
  end
end
