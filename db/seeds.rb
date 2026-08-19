# Seeds a full Linguio course:
#   Course (French Essentials, A1) -> CourseSection (Foundations)
#     -> Lesson (Greetings & Introductions)
#     -> Lesson (Numbers & Time)
#     -> Lesson (Colors & Descriptions)
#     -> Lesson (Basic Questions)
#   -> CourseSection (Daily Life)
#     -> Lesson (At the Café)
#
# Each full lesson: Vocabulary (flashcard set + matching), Grammar (fill_blank),
# Conversation (dialogue).
#
# Run with: rails db:seed
# Safe to re-run: find_or_create_by! makes this idempotent.

course = Course.find_or_create_by!(title: "French Essentials") do |c|
  c.description = "A structured path from A1 beginner to solid B1 intermediate, built on the Progressive French method."
  c.level = "A1"
  c.language = "fr"
end

# --- Helper: builds the standard 4-part lesson shape --------------------

def seed_full_lesson(section, title:, position:, flashcards:, pairs:, fill_blank_questions:, dialogue_lines:)
  lesson = section.lessons.find_or_create_by!(title: title) do |l|
    l.position = position
  end

  vocabulary_section = lesson.lesson_sections.find_or_create_by!(title: "Vocabulary") do |ls|
    ls.section_type = "vocabulary"
    ls.position = 1
  end

  vocabulary_section.exercises.find_or_create_by!(exercise_type: "flashcard", position: 1) do |e|
    e.content = {
      cards: flashcards.map { |card|
        { front: { word: card[:word] }, back: { translation: card[:translation], example: card[:example] } }
      }
    }
  end

  vocabulary_section.exercises.find_or_create_by!(exercise_type: "matching", position: 2) do |e|
    e.content = { pairs: pairs.map { |l, r| { left: l, right: r } } }
  end

  grammar_section = lesson.lesson_sections.find_or_create_by!(title: "Grammar") do |ls|
    ls.section_type = "grammar"
    ls.position = 2
  end

  grammar_section.exercises.find_or_create_by!(exercise_type: "fill_blank", position: 1) do |e|
    e.content = { questions: fill_blank_questions }
  end

  conversation_section = lesson.lesson_sections.find_or_create_by!(title: "Conversation") do |ls|
    ls.section_type = "conversation"
    ls.position = 3
  end

  conversation_section.exercises.find_or_create_by!(exercise_type: "dialogue", position: 1) do |e|
    e.content = { lines: dialogue_lines }
  end

  lesson
end

# --- Section 1: Foundations ----------------------------------------------

foundations = course.course_sections.find_or_create_by!(title: "Foundations") do |s|
  s.position = 1
end

seed_full_lesson(
  foundations,
  title: "Greetings & Introductions",
  position: 1,
  flashcards: [
    { word: "bonjour",         translation: "hello",     example: "Bonjour, Marie !" },
    { word: "merci",           translation: "thank you", example: "Merci beaucoup !" },
    { word: "salut",           translation: "hi / bye",  example: "Salut, à bientôt !" },
    { word: "s'il vous plaît", translation: "please",    example: "Un café, s'il vous plaît." }
  ],
  pairs: [
    %w[chat cat], %w[chien dog], %w[maison house], %w[ami friend]
  ],
  fill_blank_questions: [
    { sentence: "Je ___ français.",   answer: "parle",  alternatives: [ "parle" ],  hint: "verb: parler" },
    { sentence: "Tu ___ anglais.",    answer: "parles", alternatives: [ "parles" ], hint: "verb: parler" },
    { sentence: "Elle ___ espagnol.", answer: "parle",  alternatives: [ "parle" ],  hint: "verb: parler" }
  ],
  dialogue_lines: [
    { speaker: "Marie", text: "Bonjour !" },
    { speaker: "Paul", text: "", options: [
      { text: "Bonjour ! Comment ça va ?", correct: true },
      { text: "Au revoir !", correct: false }
    ] },
    { speaker: "Marie", text: "Ça va bien, merci. Et toi ?" },
    { speaker: "Paul", text: "", options: [
      { text: "Ça va, merci !", correct: true },
      { text: "Je m'appelle Paul.", correct: false }
    ] }
  ]
)

seed_full_lesson(
  foundations,
  title: "Numbers & Time",
  position: 2,
  flashcards: [
    { word: "un",    translation: "one",   example: "J'ai un frère." },
    { word: "deux",  translation: "two",   example: "Deux cafés, s'il vous plaît." },
    { word: "trois", translation: "three", example: "Il est trois heures." },
    { word: "heure", translation: "hour / o'clock", example: "Quelle heure est-il ?" }
  ],
  pairs: [
    %w[un one], %w[deux two], %w[trois three], %w[heure hour]
  ],
  fill_blank_questions: [
    { sentence: "Il est ___ heures.", answer: "trois", alternatives: [ "trois" ], hint: "number: 3" },
    { sentence: "J'ai ___ chats.",    answer: "deux",  alternatives: [ "deux" ],  hint: "number: 2" }
  ],
  dialogue_lines: [
    { speaker: "Paul", text: "Quelle heure est-il ?" },
    { speaker: "Marie", text: "", options: [
      { text: "Il est trois heures.", correct: true },
      { text: "Il fait beau.", correct: false }
    ] }
  ]
)

seed_full_lesson(
  foundations,
  title: "Colors & Descriptions",
  position: 3,
  flashcards: [
    { word: "bleu(e)",  translation: "blue",  example: "Le ciel est bleu." },
    { word: "rouge",    translation: "red",   example: "La pomme est rouge." },
    { word: "vert(e)",  translation: "green", example: "L'herbe est verte." },
    { word: "jaune",    translation: "yellow", example: "Le soleil est jaune." },
    { word: "grand(e)", translation: "big, tall", example: "Il est très grand." },
    { word: "petit(e)", translation: "small", example: "Le chat est petit." }
  ],
  pairs: [
    %w[petit small], %w[rouge red], %w[vert green], %w[bleu blue], %w[jaune yellow], %w[grand big,\ tall]
  ],
  fill_blank_questions: [
    { sentence: "Le ciel est ___ aujourd'hui.", answer: "bleu", alternatives: [ "bleu", "bleue" ], hint: "bleu(e)" }
  ],
  dialogue_lines: [
    { speaker: "Guide", text: "Qu'est-ce que vous pensez de ce tableau ?" },
    { speaker: "You", text: "C'est très beau — j'aime les couleurs." },
    { speaker: "Guide", text: "Quelle est votre couleur préférée ?" },
    { speaker: "You", text: "", options: [
      { text: "Ma couleur préférée est le bleu.", correct: true },
      { text: "Ma couleur c'est.", correct: false },
      { text: "Rouge est moi.", correct: false },
      { text: "J'aime rouge très bien.", correct: false }
    ] }
  ]
)

seed_full_lesson(
  foundations,
  title: "Basic Questions",
  position: 4,
  flashcards: [
    { word: "qui",       translation: "who",  example: "Qui est-ce ?" },
    { word: "quoi",      translation: "what", example: "C'est quoi ?" },
    { word: "où",        translation: "where", example: "Où est la gare ?" },
    { word: "quand",     translation: "when", example: "Quand arrives-tu ?" },
    { word: "pourquoi",  translation: "why",  example: "Pourquoi pas ?" },
    { word: "comment",   translation: "how",  example: "Comment ça va ?" }
  ],
  pairs: [
    %w[qui who], %w[quoi what], %w[où where], %w[quand when], %w[pourquoi why], %w[comment how]
  ],
  fill_blank_questions: [
    { sentence: "___ est la gare ?", answer: "Où", alternatives: [ "où" ], hint: "where" },
    { sentence: "___ ça va ?",       answer: "Comment", alternatives: [ "comment" ], hint: "how" }
  ],
  dialogue_lines: [
    { speaker: "Marie", text: "Comment tu t'appelles ?" },
    { speaker: "Paul", text: "", options: [
      { text: "Je m'appelle Paul.", correct: true },
      { text: "Il est trois heures.", correct: false }
    ] }
  ]
)

# --- Section 2: Daily Life (locked until Foundations is complete) --------

daily_life = course.course_sections.find_or_create_by!(title: "Daily Life") do |s|
  s.position = 2
end

seed_full_lesson(
  daily_life,
  title: "At the Café",
  position: 1,
  flashcards: [
    { word: "un café",    translation: "a coffee",  example: "Un café, s'il vous plaît." },
    { word: "l'addition", translation: "the bill",  example: "L'addition, s'il vous plaît." },
    { word: "délicieux",  translation: "delicious", example: "C'est délicieux !" }
  ],
  pairs: [
    %w[café coffee], %w[addition bill], %w[délicieux delicious]
  ],
  fill_blank_questions: [
    { sentence: "C'est très ___.", answer: "délicieux", alternatives: [ "délicieux", "délicieuse" ], hint: "délicieux" }
  ],
  dialogue_lines: [
    { speaker: "Waiter", text: "Qu'est-ce que vous voulez ?" },
    { speaker: "You", text: "", options: [
      { text: "Un café, s'il vous plaît.", correct: true },
      { text: "L'addition, s'il vous plaît.", correct: false }
    ] }
  ]
)

puts "Seeded: #{course.title}"
course.course_sections.order(:position).each do |s|
  puts "  #{s.title} (position #{s.position})"
  s.lessons.order(:position).each do |l|
    puts "    #{l.title} (position #{l.position}) — #{l.lesson_sections.count} lesson sections, #{l.exercises.count} exercises"
  end
end
