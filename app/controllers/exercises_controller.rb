class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise

  def show
  end

  def submit
    score = params[:known] == "true" ? 100 : 0

    current_user.exercise_attempts.create!(
      exercise: @exercise,
      status: :completed,
      score: score,
      completed_at: Time.current
    )

    next_exercise = @exercise.next_exercise

    if next_exercise
      redirect_to lesson_lesson_section_exercise_path(
        next_exercise.lesson, next_exercise.lesson_section, next_exercise
      )
    else
      redirect_to @lesson, notice: "Lesson complete!"
    end
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
    @lesson_section = @exercise.lesson_section
    @lesson = @exercise.lesson
  end
end