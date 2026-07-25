class Exercise < ApplicationRecord
  belongs_to :lesson_section

  has_many :exercise_vocabulary_items, dependent: :destroy
  has_many :vocabulary_items, through: :exercise_vocabulary_items
  has_many :exercise_attempts, dependent: :destroy
end
