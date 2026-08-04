# Linguio 🇫🇷

**Linguio** is an interactive language learning platform designed to help learners build practical French skills through structured lessons, vocabulary training, grammar practice, and exam-oriented preparation.

The first version focuses on helping learners prepare for French proficiency exams such as **TEF Canada** and **TCF Canada**, while keeping the platform flexible enough to support multiple languages in the future.

## 🚀 Features

### Learning Experience

* Structured French courses from beginner to advanced levels
* Vocabulary training with spaced repetition
* Grammar explanations and exercises
* Interactive practice activities:

  * Flashcards
  * Fill-in-the-blank exercises
  * Matching activities
  * Pronunciation practice
  * Comprehension exercises

### Exam Preparation

* TEF Canada / TCF Canada focused practice
* Vocabulary expansion for real-world communication
* Grammar reinforcement
* Skills-based learning paths

### Content Management

* Admin interface for creating and managing:

  * Courses
  * Lessons
  * Vocabulary lists
  * Grammar topics
  * Exercises

## 🛠 Tech Stack

### Backend

* Ruby on Rails 8.1
* PostgreSQL
* Ruby 3.3+

### Frontend

* Hotwire (Turbo + Stimulus)
* Tailwind CSS
* HTML / CSS / JavaScript

### Development Tools

* Git & GitHub
* RSpec for testing
* Docker (planned)

## 📂 Project Structure

```
linguio/
├── app/
│   ├── models/        # Database models
│   ├── controllers/   # Application logic
│   ├── views/        # User interface
│   └── javascript/   # Frontend interactions
│
├── config/            # Rails configuration
├── db/                # Database migrations and seeds
├── test/              # Tests
└── README.md
```

## ⚙️ Installation

### Prerequisites

Make sure you have installed:

* Ruby 3.3+
* Rails
* PostgreSQL
* Node.js

### Setup

Clone the repository:

```bash
git clone git@github.com:YOUR_USERNAME/linguio.git
cd linguio
```

Install dependencies:

```bash
bundle install
```

Create and prepare the database:

```bash
rails db:create
rails db:migrate
```

Start the development server:

```bash
bin/dev
```

The application will be available at:

```
http://localhost:3000
```

## 🧪 Testing

Run the test suite:

```bash
rspec
```

## 🗺 Roadmap

### Phase 1 — Lesson Player + Content Authoring (in progress)
* [x] Rails 8.1 + Devise auth (student/admin roles)
* [x] Core schema: Course → CourseSection → Lesson → LessonSection → Exercise
* [x] Vocabulary as a global, language-scoped pool
* [x] Flashcard exercise: full player loop (reveal → self-assess → submit → result → advance)
* [ ] Admin CRUD: Course → CourseSection → Lesson → LessonSection (foundational — unblocks manual content creation)
* [ ] Flashcard: admin authoring form (type-specific fields — front word, back translation, audio, example — not a generic JSON editor)
* [ ] Matching: lock JSON shape → player → admin form — up next
* [ ] Fill-in-the-blank: lock JSON shape → player → admin form
* [ ] Dialogue: lock JSON shape → player → admin form
* [ ] Admin CRUD: VocabularyItem (global pool)
* [ ] Slugs on courses/course_sections/lessons
* [ ] Lesson flow polish: section transitions, completion screen, minimal progress indicator ("3/8 exercises," "2/4 sections" — no XP, streaks, mastery %, or skill trees; that's Phase 3 territory)

### Phase 2 — Listening & Speaking
* [ ] media_assets (polymorphic) for audio content
* [ ] Listening: audio assets + comprehension questions (player + admin form, same locked-shape-first pattern)
* [ ] Speaking: recording, playback, transcription, feedback — the largest technical unknown in the roadmap (pronunciation scoring, phoneme accuracy, accent tolerance, and latency are genuinely hard problems, not just "audio + speech API")

### Phase 3 — Review & Analytics
* [ ] `context` field on ExerciseAttempt (lesson/review)
* [ ] Weak content review — derived from recent attempt history, no mastery table
* [ ] Endless review fallback — cycles known vocab across existing exercise types
* [ ] Per-question analytics (exercise_attempt_answers)
* [ ] Progress tracking (derived from ExerciseAttempt, not stored separately) — ExerciseAttempt stays the immutable event log; everything else is a projection over it
* [ ] *(deferred within this phase)* SM-2 scheduling (`ease_factor`, `interval_days`) — only after weak/endless review is observable in practice; classic SM-2 may not be the right fit for an exercise-based model

### Phase 4 — Exam Preparation
* [ ] Tagging schema on Exercise (e.g. `["a1", "greetings", "tef_speaking"]`) for exam-structure alignment
* [ ] TEF/TCF exam-structure tagging
* [ ] Shared free-text exercise infrastructure (e.g. "use it in a sentence," writing tasks) — divergent scoring strategies per use case: lightweight/AI-assisted validation for review sentences vs. rubric-based criteria (length, coherence, register) for TEF/TCF writing

### Phase 5 — Expansion
* [ ] Multi-language support (Russian next; schema already language-agnostic)
* [ ] Mobile application

## 🎯 Vision

Linguio aims to combine the structure of traditional language textbooks with the engagement of modern learning applications.

Instead of memorizing isolated words or completing repetitive exercises, learners follow a clear path that connects vocabulary, grammar, and real communication skills.

## 🤝 Contributing

Contributions, suggestions, and feedback are welcome.

If you would like to contribute:

1. Fork the repository
2. Create a feature branch

```bash
git checkout -b feature/new-feature
```

3. Commit your changes

```bash
git commit -m "Add new feature"
```

4. Push the branch

```bash
git push origin feature/new-feature
```

5. Open a Pull Request

## 📄 License

This project is currently under development.
License information will be added in the future.

---

Built with ❤️ while learning, teaching, and building better ways to learn languages.