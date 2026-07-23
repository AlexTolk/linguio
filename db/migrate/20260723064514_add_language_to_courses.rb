class AddLanguageToCourses < ActiveRecord::Migration[8.1]
  def change
    add_column :courses, :language, :string, null: false, default: "fr"
  end
end
