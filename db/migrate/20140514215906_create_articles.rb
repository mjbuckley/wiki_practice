class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :page_id
      t.string :title

      t.timestamps
    end
    add_index :articles, :page_id, unique: true
  end
end
