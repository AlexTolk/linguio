class AddContextToExerciseAttempts < ActiveRecord::Migration[8.1]
  def change
    add_column :exercise_attempts, :context, :integer, default: 0, null: false
    add_index :exercise_attempts, :context
  end
end
