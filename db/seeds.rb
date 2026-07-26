# Seeds the first real Linguio lesson end-to-end:
#   Course (French A1) -> CourseSection (Greetings) -> Lesson (Bonjour)
#     -> LessonSection (Vocabulary)   -> Exercise (flashcard) x4
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

# One Exercise row per flashcard, matching the locked contract:
#   content: { front: { word: }, back: { translation:, example: } }
flashcards = [
  { word: "bonjour",         translation: "hello",     example: "Bonjour, Marie !" },
  { word: "merci",           translation: "thank you", example: "Merci beaucoup !" },
  { word: "salut",           translation: "hi / bye",  example: "Salut, à bientôt !" },
  { word: "s'il vous plaît", translation: "please",    example: "Un café, s'il vous plaît." }
]

flashcards.each_with_index do |card, index|
  vocabulary_section.exercises.find_or_initialize_by(exercise_type: "flashcard", position: index + 1).tap do |e|
    e.content = {
      front: { word: card[:word] },
      back: { translation: card[:translation], example: card[:example] }
    }
    e.save!
  end
end

vocabulary_section.exercises.find_or_create_by!(exercise_type: "matching", position: flashcards.size + 1) do |e|
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
      { sentence: "Je ___ français.",   answer: "parle",  alternatives: ["parle"],  hint: "verb: parler" },
      { sentence: "Tu ___ anglais.",    answer: "parles", alternatives: ["parles"], hint: "verb: parler" },
      { sentence: "Elle ___ espagnol.", answer: "parle",  alternatives: ["parle"],  hint: "verb: parler" }
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
      { speaker: "Marie", text: "Bonjour !",                     translation: "Hello!" },
      { speaker: "Paul",  text: "Bonjour ! Comment ça va ?",      translation: "Hello! How are you?" },
      { speaker: "Marie", text: "Ça va bien, merci. Et toi ?",    translation: "I'm doing well, thanks. And you?" },
      { speaker: "Paul",  text: "Ça va, merci !",                 translation: "I'm good, thanks!" }
    ]
  }
end

puts "Seeded: #{course.title} → #{section.title} → #{lesson.title}"
puts "  #{lesson.lesson_sections.count} lesson sections"
puts "  #{Exercise.joins(:lesson_section).where(lesson_sections: { lesson_id: lesson.id }).count} exercises"