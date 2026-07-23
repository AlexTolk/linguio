# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_23_064710) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "course_sections", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_sections_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "language", default: "fr", null: false
    t.string "level"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "exercises", force: :cascade do |t|
    t.jsonb "content", default: {}, null: false
    t.datetime "created_at", null: false
    t.string "exercise_type"
    t.bigint "lesson_section_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["lesson_section_id"], name: "index_exercises_on_lesson_section_id"
  end

  create_table "lesson_sections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.integer "position"
    t.string "section_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["lesson_id", "position"], name: "index_lesson_sections_on_lesson_id_and_position", unique: true
    t.index ["lesson_id"], name: "index_lesson_sections_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.text "content"
    t.bigint "course_section_id", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["course_section_id"], name: "index_lessons_on_course_section_id"
  end

  add_foreign_key "course_sections", "courses"
  add_foreign_key "exercises", "lesson_sections"
  add_foreign_key "lesson_sections", "lessons"
  add_foreign_key "lessons", "course_sections"
end
