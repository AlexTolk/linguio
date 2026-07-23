class LessonSection < ApplicationRecord
  belongs_to :lesson
  has_many :exercises, -> { order(:position) }, dependent: :destroy
end
