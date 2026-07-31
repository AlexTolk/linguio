class CreateExerciseAttemptAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_attempt_answers do |t|
      t.references :exercise_attempt, null: false, foreign_key: true
      t.string :item_key, null: false
      t.string :given_answer
      t.string :correct_answer
      t.boolean :correct, null: false

      t.timestamps
    end
  end
end
