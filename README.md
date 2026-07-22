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

* Ruby on Rails
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

### Phase 1 — Foundation

* [x] Rails application setup
* [x] Database design
* [ ] User authentication
* [ ] Course structure
* [ ] Basic lesson interface

### Phase 2 — Learning System

* [ ] Vocabulary database
* [ ] Grammar lessons
* [ ] Interactive exercises
* [ ] Progress tracking

### Phase 3 — Exam Preparation

* [ ] TEF/TCF vocabulary modules
* [ ] Listening practice
* [ ] Writing tasks
* [ ] Speaking simulations

### Phase 4 — Expansion

* [ ] Additional languages
* [ ] Mobile application
* [ ] AI-powered learning assistants
* [ ] Personalized learning paths

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
