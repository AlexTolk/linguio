module Admin
  class CourseSectionsController < Admin::BaseController
    before_action :set_course
    before_action :set_course_section, only: [:edit, :update, :destroy]

    def new
      @course_section = @course.course_sections.build(
        position: next_position
      )
    end

    def create
      @course_section = @course.course_sections.build(course_section_params)

      if @course_section.save
        redirect_to admin_course_path(@course), notice: "Section created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @course_section.update(course_section_params)
        redirect_to admin_course_path(@course), notice: "Section updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @course_section.destroy
      redirect_to admin_course_path(@course), notice: "Section deleted."
    end

    private

    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_course_section
      @course_section = @course.course_sections.find(params[:id])
    end

    def course_section_params
      params.require(:course_section).permit(:title, :position)
    end

    def next_position
      (@course.course_sections.maximum(:position) || 0) + 1
    end
  end
end