class CreateLessonSections < ActiveRecord::Migration[8.1]
  def change
    create_table :lesson_sections do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :title
      t.string :section_type
      t.integer :position

      t.timestamps
    end
  end
end
