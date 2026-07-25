class ExerciseVocabularyItem < ApplicationRecord
  belongs_to :exercise
  belongs_to :vocabulary_item

  validates :vocabulary_item_id, uniqueness: { scope: :exercise_id }
end
