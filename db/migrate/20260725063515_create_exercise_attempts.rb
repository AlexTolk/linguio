class CreateExerciseAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.integer :score
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
    add_index :exercise_attempts, [:user_id, :exercise_id]
  end
end
