class CreateVocabularyReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :vocabulary_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vocabulary_item, null: false, foreign_key: true
      t.integer :status, default: 0, null: false   # new/learning/known
      t.integer :review_count, default: 0, null: false
      t.datetime :last_reviewed_at
      t.datetime :next_review_at

      t.timestamps
    end
    add_index :vocabulary_reviews, [:user_id, :vocabulary_item_id], unique: true
  end
end