class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.integer :user_id
      t.integer :page_id
      t.integer :rev_id
      t.text :comment

      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :page_id
  end
end
