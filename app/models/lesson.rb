class Lesson < ApplicationRecord
  belongs_to :course_section
  has_many :lesson_sections, -> { order(:position) }, dependent: :destroy
end
