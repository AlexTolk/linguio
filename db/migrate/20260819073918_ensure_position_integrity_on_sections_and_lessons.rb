class EnsurePositionIntegrityOnSectionsAndLessons < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE course_sections cs
      SET position = sub.rn
      FROM (
        SELECT id, ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY position NULLS LAST, id) AS rn
        FROM course_sections
      ) sub
      WHERE cs.id = sub.id;
    SQL

    execute <<~SQL
      UPDATE lessons l
      SET position = sub.rn
      FROM (
        SELECT id, ROW_NUMBER() OVER (PARTITION BY course_section_id ORDER BY position NULLS LAST, id) AS rn
        FROM lessons
      ) sub
      WHERE l.id = sub.id;
    SQL

    change_column_null :course_sections, :position, false
    change_column_null :lessons, :position, false
  end

  def down
    change_column_null :course_sections, :position, true
    change_column_null :lessons, :position, true
  end
end
