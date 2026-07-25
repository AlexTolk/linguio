class CreateVocabularyItemsAndExerciseVocabularyItems < ActiveRecord::Migration[8.1]
  def change
    create_table :vocabulary_items do |t|
      t.string :language, null: false, default: "fr"
      t.string :word, null: false
      t.string :translation, null: false
      t.string :translation_language, null: false, default: "en"

      t.string :part_of_speech
      t.text   :example_sentence
      t.text   :translation_sentence
      t.string :audio_url
      t.string :difficulty_level

      t.timestamps
    end
    add_index :vocabulary_items, [:language, :word]

    create_table :exercise_vocabulary_items do |t|
      t.references :exercise, null: false, foreign_key: true
      t.references :vocabulary_item, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :exercise_vocabulary_items, [:exercise_id, :vocabulary_item_id],
              unique: true, name: "index_exercise_vocab_uniqueness"
  end
end
