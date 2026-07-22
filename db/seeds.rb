course = Course.create!(
  title: "French A1 Beginner",
  description: "Build your French foundations with vocabulary, grammar and practical exercises.",
  level: "A1"
)

section = course.course_sections.create!(
  title: "First Conversations",
  position: 1
)

section.lessons.create!(
  title: "Greetings in French",
  content: "Bonjour, salut, au revoir, merci...",
  position: 1
)

section.lessons.create!(
  title: "Introducing Yourself",
  content: "Je m'appelle..., Je suis..., J'habite à...",
  position: 2
)
