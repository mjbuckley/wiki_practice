class Review < ActiveRecord::Base
  belongs_to :user
  validates :rating, presence: true
  validates :user_id, presence: true
  validates :page_id, presence: true
  validates :rev_id, presence: true
  validates :comment, presence: true
  validates :title, presence: true
end
