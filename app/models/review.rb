class Review < ActiveRecord::Base
  belongs_to :user
  # Not sure the belongs_to is correct. It seems to work ok, but make sure it works and the syntax is correct.
  belongs_to :article, primary_key: :page_id, foreign_key: "page_id"
  validates :rating, presence: true
  validates :user_id, presence: true
  validates :page_id, presence: true
  validates :rev_id, presence: true
  validates :comment, presence: true
  validates :title, presence: true
end
