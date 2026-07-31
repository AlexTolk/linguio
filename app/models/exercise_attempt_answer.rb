class ExerciseAttemptAnswer < ApplicationRecord
  belongs_to :exercise_attempt

  validates :item_key, presence: true
  validates :correct, inclusion: { in: [true, false] }
end