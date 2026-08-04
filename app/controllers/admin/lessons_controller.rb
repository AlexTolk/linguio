module Admin
  class LessonsController < Admin::BaseController
    before_action :set_course_section
    before_action :set_lesson, only: [:show, :edit, :update, :destroy]

    def show
    end

    def new
      @lesson = @course_section.lessons.build(position: next_position)
    end

    def create
      @lesson = @course_section.lessons.build(lesson_params)

      if @lesson.save
        redirect_to admin_course_path(@course_section.course), notice: "Lesson created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @lesson.update(lesson_params)
        redirect_to admin_course_path(@course_section.course), notice: "Lesson updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @lesson.destroy
      redirect_to admin_course_path(@course_section.course), notice: "Lesson deleted."
    end

    private

    def set_course_section
      @course_section = CourseSection.find(params[:course_section_id])
    end

    def set_lesson
      @lesson = @course_section.lessons.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(:title, :content, :position)
    end

    def next_position
      (@course_section.lessons.maximum(:position) || 0) + 1
    end
  end
end