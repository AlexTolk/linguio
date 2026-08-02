class Lesson < ApplicationRecord
  belongs_to :course_section
  has_many :lesson_sections, -> { order(:position) }, dependent: :destroy
  has_many :exercises, through: :lesson_sections

  def completed_by?(user)
    exercise_ids = exercises.pluck(:id)
    return false if exercise_ids.empty?

    attempted_ids = ExerciseAttempt.for_user(user).completed
                                    .where(exercise_id: exercise_ids)
                                    .distinct.pluck(:exercise_id)

    (exercise_ids - attempted_ids).empty?
  end

  def first_exercise
    lesson_sections.first&.exercises&.order(:position)&.first
  end

  # Average of each exercise's most recent completed attempt.
  # Returns nil if the user hasn't attempted anything in this lesson yet.
  def score_for(user)
    exercise_ids = exercises.pluck(:id)
    return nil if exercise_ids.empty?

    latest_scores = ExerciseAttempt.for_user(user).completed
                                    .where(exercise_id: exercise_ids)
                                    .order(completed_at: :desc)
                                    .group_by(&:exercise_id)
                                    .transform_values { |attempts| attempts.first.score }

    return nil if latest_scores.empty?

    (latest_scores.values.sum.to_f / latest_scores.size).round
  end
end