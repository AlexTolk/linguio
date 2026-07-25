# app/models/exercise_attempt.rb
class ExerciseAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  enum :status, { not_started: 0, in_progress: 1, completed: 2 }
end