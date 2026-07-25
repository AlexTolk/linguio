class ExercisesController < ApplicationController
  def show
    @lesson = Lesson.find(params[:lesson_id])
    @lesson_section = @lesson.lesson_sections.find(params[:lesson_section_id])
    @exercise = @lesson_section.exercises.find(params[:id])
  end
end
