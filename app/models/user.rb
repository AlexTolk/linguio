class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :role, { student: 0, admin: 1 }
  validates :target_exam, inclusion: { in: %w[tef tcf], allow_nil: true }

  has_many :exercise_attempts, dependent: :destroy
  has_many :vocabulary_reviews, dependent: :destroy
end
