class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :creator_id
      t.datetime :published_at
      t.boolean :featured
      t.timestamps
    end
  end
end
