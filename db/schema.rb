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

ActiveRecord::Schema[8.1].define(version: 2026_07_31_104914) do
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

  create_table "exercise_attempt_answers", force: :cascade do |t|
    t.boolean "correct"
    t.string "correct_answer"
    t.datetime "created_at", null: false
    t.bigint "exercise_attempt_id", null: false
    t.string "given_answer"
    t.string "item_key"
    t.datetime "updated_at", null: false
    t.index ["exercise_attempt_id"], name: "index_exercise_attempt_answers_on_exercise_attempt_id"
  end

  create_table "exercise_attempts", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "exercise_id", null: false
    t.integer "score"
    t.datetime "started_at"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["exercise_id"], name: "index_exercise_attempts_on_exercise_id"
    t.index ["user_id", "exercise_id"], name: "index_exercise_attempts_on_user_id_and_exercise_id"
    t.index ["user_id"], name: "index_exercise_attempts_on_user_id"
  end

  create_table "exercise_vocabulary_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "exercise_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "vocabulary_item_id", null: false
    t.index ["exercise_id", "vocabulary_item_id"], name: "index_exercise_vocab_uniqueness", unique: true
    t.index ["exercise_id"], name: "index_exercise_vocabulary_items_on_exercise_id"
    t.index ["vocabulary_item_id"], name: "index_exercise_vocabulary_items_on_vocabulary_item_id"
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

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.string "target_exam"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabulary_items", force: :cascade do |t|
    t.string "audio_url"
    t.datetime "created_at", null: false
    t.string "difficulty_level"
    t.text "example_sentence"
    t.string "language", default: "fr", null: false
    t.string "part_of_speech"
    t.string "translation", null: false
    t.string "translation_language", default: "en", null: false
    t.text "translation_sentence"
    t.datetime "updated_at", null: false
    t.string "word", null: false
    t.index ["language", "word"], name: "index_vocabulary_items_on_language_and_word"
  end

  create_table "vocabulary_reviews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "last_reviewed_at"
    t.datetime "next_review_at"
    t.integer "review_count", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "vocabulary_item_id", null: false
    t.index ["user_id", "vocabulary_item_id"], name: "index_vocabulary_reviews_on_user_id_and_vocabulary_item_id", unique: true
    t.index ["user_id"], name: "index_vocabulary_reviews_on_user_id"
    t.index ["vocabulary_item_id"], name: "index_vocabulary_reviews_on_vocabulary_item_id"
  end

  add_foreign_key "course_sections", "courses"
  add_foreign_key "exercise_attempt_answers", "exercise_attempts"
  add_foreign_key "exercise_attempts", "exercises"
  add_foreign_key "exercise_attempts", "users"
  add_foreign_key "exercise_vocabulary_items", "exercises"
  add_foreign_key "exercise_vocabulary_items", "vocabulary_items"
  add_foreign_key "exercises", "lesson_sections"
  add_foreign_key "lesson_sections", "lessons"
  add_foreign_key "lessons", "course_sections"
  add_foreign_key "vocabulary_reviews", "users"
  add_foreign_key "vocabulary_reviews", "vocabulary_items"
end
