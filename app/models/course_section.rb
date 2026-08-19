class CourseSection < ApplicationRecord
  belongs_to :course
  has_many :lessons, -> { order(:position) }, dependent: :destroy
  validates :position, presence: true
end
