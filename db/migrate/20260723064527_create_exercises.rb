class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises do |t|
      t.references :lesson_section, null: false, foreign_key: true
      t.string :exercise_type
      t.jsonb :content, null: false, default: {}
      t.integer :position

      t.timestamps
    end
  end
end
