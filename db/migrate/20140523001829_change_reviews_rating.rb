class ChangeReviewsRating < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :reviews do |t|
        dir.up { t.change :rating, :string }
        dir.down { t.change :rating, :integer }
      end
    end
  end
end
