class Course < ApplicationRecord
    has_many :course_sections, -> { order(:position) }, dependent: :destroy
end
