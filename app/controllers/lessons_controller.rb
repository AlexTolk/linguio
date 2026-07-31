class LessonsController < ApplicationController
  def show
    @lesson = Lesson.includes(lesson_sections: :exercises).find(params[:id])
    @latest_scores = latest_scores_by_exercise
  end

  private

  # One query for the whole lesson, keyed by exercise_id => most recent
  # completed score. Used only for per-exercise Start/Review badges below;
  # the lesson- and section-level totals use Lesson#score_for /
  # LessonSection#score_for instead, since those are reused elsewhere.
  def latest_scores_by_exercise
    return {} unless user_signed_in?

    exercise_ids = @lesson.lesson_sections.flat_map(&:exercises).map(&:id)

    ExerciseAttempt.for_user(current_user).completed
                    .where(exercise_id: exercise_ids)
                    .order(completed_at: :desc)
                    .group_by(&:exercise_id)
                    .transform_values { |attempts| attempts.first.score }
  end
end