# Linguio: Copilot Development Guide

A Rails 8.1.3 application for interactive French language learning with exam preparation (TEF/TCF), featuring user authentication, structured courses, and interactive exercises.

## Quick Start Commands

```bash
# Install dependencies and setup database
bundle install
rails db:create db:migrate

# Run development server (Hotwire + Tailwind CSS)
bin/dev

# Run tests (Minitest, parallel execution)
rails test

# Run specific test file
rails test test/models/course_test.rb

# Run single test method
rails test test/models/course_test.rb:CourseTest
```

## Linting & Security

```bash
# Linting (Omakase style rules)
rubocop

# Security audit for gems
bundler-audit

# Security scanner for Rails code
brakeman
```

## Architecture

### Domain Model Hierarchy
The core learning structure follows a clear nested pattern:

```
Course
├── CourseSection (multiple)
│   └── Lesson (multiple)
│       └── LessonSection (ordered by position)
│           └── Exercise (ordered by position)
```

**Key insight**: Lessons contain LessonSections (not Exercises directly). This allows lessons to have structured content blocks with exercises within each block. Position ordering is crucial for maintaining sequence.

### Authentication & Authorization
- **Devise gem**: Handles user authentication (database_authenticatable, registerable, recoverable, rememberable, validatable)
- **User roles**: Enum with `:student` (0) and `:admin` (1)
- **Target exam**: User can select TEF or TCF (validated in enum)
- Controllers don't yet enforce authentication/authorization—add `before_action :authenticate_user!` and role checks as features develop

### Frontend Architecture
- **Hotwire**: Turbo for SPA-like navigation, Stimulus for JavaScript controllers
- **CSS**: Tailwind CSS 4.6 (watch via `bin/dev`)
- **No API mode**: Views are ERB templates with Stimulus controllers in `app/javascript/controllers/`
- **Asset pipeline**: Propshaft (modern Rails asset handling)

### Controllers & Routes
Nested resource routing reflects the learning hierarchy:
```ruby
resources :courses, only: [:index, :show]
resources :lessons, only: [:show] do
  resources :lesson_sections, only: [] do
    resources :exercises, only: [:show]
  end
end
```
Controllers use eager loading with `includes()` to avoid N+1 queries (see `CoursesController#show`).

## Key Conventions

### Testing (Minitest)
- **Location**: `test/` (models, controllers, integration, system, fixtures)
- **Fixtures**: YAML files in `test/fixtures/` auto-loaded for all tests
- **Parallel execution**: Default behavior via `parallelize` in test_helper.rb
- **Naming**: `*_test.rb` files inherit from `ActiveSupport::TestCase`
- **README mentions RSpec** but codebase uses Minitest—ignore RSpec references

### Model Patterns
- Use `dependent: :destroy` on all `has_many` associations (prevents orphaned records)
- Order associations explicitly with lambdas: `has_many :lesson_sections, -> { order(:position) }`
- Enums for fixed value sets (User#role, User#target_exam)
- Validations in model, not just DB constraints

### Controller Patterns
- Use `includes()` for nested resource queries to prevent N+1
- Keep controllers thin—no business logic
- Example: `Course.includes(course_sections: :lessons)` loads full hierarchy in one query

### Database
- PostgreSQL required
- Migrations use Rails generators (keep them idempotent)
- Unique constraints enforced (see `lesson_sections` position uniqueness migration)

### Linting & Code Style
- **RuboCop Omakase**: Use as-is (inherited from gem, minimal overrides in `.rubocop.yml`)
- **No custom style rules**—Omakase provides Rails best practices
- Run before commits: `rubocop`

### Views & Frontend
- ERB templates with inline Stimulus controllers
- Tailwind CSS classes directly in ERB
- No separate API layer—Turbo handles dynamic updates
- View helpers in `app/helpers/` organized by controller

## Common Development Tasks

### Adding a new feature
1. Create migration: `rails generate migration AddXToModel`
2. Update model associations if needed
3. Add controller actions (index, show, new, create, etc.)
4. Create views in `app/views/controller_name/`
5. Add Stimulus controller in `app/javascript/controllers/` if interactive
6. Write tests in corresponding `test/` folder
7. Run `rubocop` before commit

### Debugging
- Use `rails console` for REPL access to models
- `binding.pry` in code requires `debug` gem (already included)
- View SQL via `rails db` or check logs in `log/development.log`
- System tests (Capybara) in `test/system/` for full feature testing

### Running tests during development
- Full suite: `rails test`
- By layer: `rails test test/models`, `rails test test/controllers`
- By file: `rails test test/models/course_test.rb`
- Watch mode: Not built-in (consider `guard-rails` if desired)

## Deployment & Configuration

- **Kamal**: Docker-based deployment gem already included
- **Credentials**: Encrypted via `config/credentials.yml.enc` (keys in `config/master.key`)
- **Solid Stack**: Uses solid_cache, solid_queue, solid_cable (Rails 8 defaults—database-backed, no Redis needed)
- **Thruster**: HTTP caching/compression for Puma included
- **Environment files**: `config/environments/` for dev/test/production

## Potential Gotchas

- **N+1 queries**: Always use `includes()` when loading related data across multiple records
- **Fixture order**: Tests load all fixtures; if you have FK constraints, ensure seed data respects dependencies
- **Devise routes**: `devise_for :users` adds auth routes automatically—don't duplicate
- **Position ordering**: LessonSection and Exercise rely on position field; never skip or duplicate position values
- **Test parallelization**: Tests run in parallel by default; avoid shared state or shared fixtures across tests
