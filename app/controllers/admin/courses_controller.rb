module Admin
  class CoursesController < Admin::BaseController
    before_action :set_course, only: [:show, :edit, :update, :destroy]

    def index
      @courses = Course.order(:language, :title)
    end

    def show
    end

    def new
      @course = Course.new
    end

    def create
      @course = Course.new(course_params)

      if @course.save
        redirect_to admin_course_path(@course), notice: "Course created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @course.update(course_params)
        redirect_to admin_course_path(@course), notice: "Course updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @course.destroy
      redirect_to admin_courses_path, notice: "Course deleted."
    end

    private

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description, :language, :level)
    end
  end
end