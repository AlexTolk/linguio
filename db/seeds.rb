# Seeds the first real Linguio lesson end-to-end:
#   Course (French A1) -> CourseSection (Greetings) -> Lesson (Bonjour)
#     -> LessonSection (Vocabulary)   -> Exercise (flashcards)
#     -> LessonSection (Vocabulary)   -> Exercise (matching)
#     -> LessonSection (Grammar)      -> Exercise (fill_blank)
#     -> LessonSection (Conversation) -> Exercise (dialogue)
#
# Run with: rails db:seed
# Safe to re-run: find_or_create_by! makes this idempotent.

course = Course.find_or_create_by!(title: "French A1") do |c|
  c.description = "Beginner French for everyday communication"
  c.level = "beginner"
  c.language = "fr"
end

section = course.course_sections.find_or_create_by!(title: "Greetings") do |s|
  s.position = 1
end

lesson = section.lessons.find_or_create_by!(title: "Bonjour") do |l|
  l.position = 1
end

# --- Section 1: Vocabulary --------------------------------------------

vocabulary_section = lesson.lesson_sections.find_or_create_by!(title: "Vocabulary") do |ls|
  ls.section_type = "vocabulary"
  ls.position = 1
end

vocabulary_section.exercises.find_or_create_by!(exercise_type: "flashcards", position: 1) do |e|
  e.content = {
    cards: [
      { front: "bonjour", back: "hello",   part_of_speech: "interjection", example: "Bonjour, Marie !" },
      { front: "merci",   back: "thank you", part_of_speech: "interjection", example: "Merci beaucoup !" },
      { front: "salut",   back: "hi / bye", part_of_speech: "interjection", example: "Salut, à bientôt !" },
      { front: "s'il vous plaît", back: "please", part_of_speech: "phrase", example: "Un café, s'il vous plaît." }
    ]
  }
end

vocabulary_section.exercises.find_or_create_by!(exercise_type: "matching", position: 2) do |e|
  e.content = {
    pairs: [
      { left: "chat",   right: "cat" },
      { left: "chien",  right: "dog" },
      { left: "maison", right: "house" },
      { left: "ami",    right: "friend" }
    ]
  }
end

# --- Section 2: Grammar -------------------------------------------------

grammar_section = lesson.lesson_sections.find_or_create_by!(title: "Grammar") do |ls|
  ls.section_type = "grammar"
  ls.position = 2
end

grammar_section.exercises.find_or_create_by!(exercise_type: "fill_blank", position: 1) do |e|
  e.content = {
    questions: [
      { sentence: "Je ___ français.",  answer: "parle",  alternatives: ["parle"],  hint: "verb: parler" },
      { sentence: "Tu ___ anglais.",   answer: "parles", alternatives: ["parles"], hint: "verb: parler" },
      { sentence: "Elle ___ espagnol.", answer: "parle", alternatives: ["parle"],  hint: "verb: parler" }
    ]
  }
end

# --- Section 3: Conversation --------------------------------------------

conversation_section = lesson.lesson_sections.find_or_create_by!(title: "Conversation") do |ls|
  ls.section_type = "conversation"
  ls.position = 3
end

conversation_section.exercises.find_or_create_by!(exercise_type: "dialogue", position: 1) do |e|
  e.content = {
    lines: [
      { speaker: "Marie", text: "Bonjour !",             translation: "Hello!" },
      { speaker: "Paul",  text: "Bonjour ! Comment ça va ?", translation: "Hello! How are you?" },
      { speaker: "Marie", text: "Ça va bien, merci. Et toi ?", translation: "I'm doing well, thanks. And you?" },
      { speaker: "Paul",  text: "Ça va, merci !",          translation: "I'm good, thanks!" }
    ]
  }
end

puts "Seeded: #{course.title} → #{section.title} → #{lesson.title}"
puts "  #{lesson.lesson_sections.count} lesson sections"
puts "  #{Exercise.joins(:lesson_section).where(lesson_sections: { lesson_id: lesson.id }).count} exercises"