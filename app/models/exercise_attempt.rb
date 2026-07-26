class ExerciseAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  enum :status, {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }

  validates :score,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            },
            allow_nil: true

  validate :completed_at_after_started_at

  scope :for_user, ->(user) { where(user:) }

  def start!
    update!(status: :in_progress, started_at: Time.current)
  end

  def complete!(score: nil)
    update!(status: :completed, score: score, completed_at: Time.current)
  end

  private

  def completed_at_after_started_at
    return if started_at.blank? || completed_at.blank?

    errors.add(:completed_at, "can't be before started_at") if completed_at < started_at
  end
end