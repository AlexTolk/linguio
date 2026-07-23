class AddUniquePositionToLessonSections < ActiveRecord::Migration[8.1]
  def change
    add_index :lesson_sections,
              [:lesson_id, :position],
              unique: true
  end
end
