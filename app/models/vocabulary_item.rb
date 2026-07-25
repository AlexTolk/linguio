class VocabularyItem < ApplicationRecord
    has_many :exercise_vocabulary_items, dependent: :destroy
    has_many :exercises, through: :exercise_vocabulary_items
    has_many :vocabulary_reviews, dependent: :destroy

    validates :language, presence: true
    validates :word, presence: true
    validates :translation, presence: true
    validates :translation_language, presence: true
end
