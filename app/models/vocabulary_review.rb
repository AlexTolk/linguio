# app/models/vocabulary_review.rb
class VocabularyReview < ApplicationRecord
  belongs_to :user
  belongs_to :vocabulary_item

  enum :status, { new_word: 0, learning: 1, known: 2 }
end