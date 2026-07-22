class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.includes(course_sections: :lessons).find(params[:id])
  end
end
