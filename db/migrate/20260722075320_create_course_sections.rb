class CreateCourseSections < ActiveRecord::Migration[8.1]
  def change
    create_table :course_sections do |t|
      t.string :title
      t.integer :position
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
