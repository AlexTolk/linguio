class LessonSectionsController < ApplicationController
  before_action :authenticate_user!

  def complete
    @lesson = Lesson.find(params[:lesson_id])
    @lesson_section = @lesson.lesson_sections.find(params[:id])
    @score = @lesson_section.score_for(current_user)
    @next_section = @lesson.lesson_sections.where("position > ?", @lesson_section.position).order(:position).first
  end
end
