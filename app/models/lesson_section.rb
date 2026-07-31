class LessonSection < ApplicationRecord
  belongs_to :lesson
  has_many :exercises, -> { order(:position) }, dependent: :destroy

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
