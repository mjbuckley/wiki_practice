class Article < ActiveRecord::Base
  # I think the below has_many is correct but not sure.  It seems to work ok, but not sure the syntax is right.
  has_many :reviews, primary_key: :page_id, foreign_key: "page_id"
  validates :page_id, presence: true, uniqueness: true
  validates :title, presence: true
end
