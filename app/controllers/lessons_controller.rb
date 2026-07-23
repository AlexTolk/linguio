class LessonsController < ApplicationController
  def show
    @lesson = Lesson.includes(lesson_sections: :exercises).find(params[:id])
  end
end
