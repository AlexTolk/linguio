module Admin
  class LessonSectionsController < Admin::BaseController
    before_action :set_lesson
    before_action :set_lesson_section, only: [:show, :edit, :update, :destroy]

    def show
    end

    def new
      @lesson_section = @lesson.lesson_sections.build(position: next_position)
    end

    def create
      @lesson_section = @lesson.lesson_sections.build(lesson_section_params)

      if @lesson_section.save
        redirect_to admin_course_section_lesson_path(@lesson.course_section, @lesson), notice: "Lesson section created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @lesson_section.update(lesson_section_params)
        redirect_to admin_course_section_lesson_path(@lesson.course_section, @lesson), notice: "Lesson section updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @lesson_section.destroy
      redirect_to admin_course_section_lesson_path(@lesson.course_section, @lesson), notice: "Lesson section deleted."
    end

    private

    def set_lesson
      @lesson = Lesson.find(params[:lesson_id])
    end

    def set_lesson_section
      @lesson_section = @lesson.lesson_sections.find(params[:id])
    end

    def lesson_section_params
      params.require(:lesson_section).permit(:title, :section_type, :position)
    end

    def next_position
      (@lesson.lesson_sections.maximum(:position) || 0) + 1
    end
  end
end