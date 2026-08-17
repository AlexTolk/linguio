class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    @courses = Course.all
    @focus_course = most_recently_active_course || @courses.first
  end

  private

  def most_recently_active_course
    last_attempt = ExerciseAttempt.for_user(current_user)
                                   .order(Arel.sql("COALESCE(completed_at, started_at) DESC"))
                                   .first
    last_attempt&.exercise&.lesson&.course_section&.course
  end
end
