class Exercise < ApplicationRecord
  belongs_to :lesson_section
  has_many :exercise_attempts, dependent: :destroy
  has_many :exercise_vocabulary_items, -> { order(:position) }, dependent: :destroy
  has_many :vocabulary_items, through: :exercise_vocabulary_items

  delegate :lesson, to: :lesson_section

  def next_exercise
    next_in_section || first_exercise_of_next_section
  end

  def partial_path
    exercise_type == "flashcard" ? "exercises/types/flashcards" : "exercises/types/#{exercise_type}"
  end

  private

  def next_in_section
    lesson_section.exercises.where("position > ?", position).order(:position).first
  end

  def first_exercise_of_next_section
    next_section = lesson.lesson_sections
                      .where("position > ?", lesson_section.position)
                      .order(:position).first

    next_section&.exercises&.order(:position)&.first
  end
end