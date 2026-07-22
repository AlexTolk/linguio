class Course < ApplicationRecord
    has_many :course_sections, dependent: :destroy
end
