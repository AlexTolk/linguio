class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :role, { student: 0, admin: 1 }
  validates :target_exam, inclusion: { in: %w[tef tcf], allow_nil: true }

  has_many :exercise_attempts, dependent: :destroy
  has_many :vocabulary_reviews, dependent: :destroy

  def display_name
    name.presence || email.split("@").first
  end

  def initials
    if name.present?
      name.split.map(&:first).first(2).join.upcase
    else
      email.first.upcase
    end
  end
end
