namespace :flashcards do
  desc "Consolidate one-exercise-per-card flashcards into one Exercise per set (content: { cards: [...] })"
  task consolidate: :environment do
    LessonSection.find_each do |section|
      flashcard_exercises = section.exercises.where(exercise_type: "flashcard").order(:position).to_a
      next if flashcard_exercises.empty?
      next if flashcard_exercises.size == 1 && flashcard_exercises.first.content.key?("cards")

      ActiveRecord::Base.transaction do
        cards = []
        vocab_links = [] # [vocabulary_item_id, card_index]

        flashcard_exercises.each_with_index do |ex, idx|
          cards << { "front" => ex.content["front"], "back" => ex.content["back"] }
          ex.exercise_vocabulary_items.each { |evi| vocab_links << [ evi.vocabulary_item_id, idx ] }
        end

        first_position = flashcard_exercises.first.position
        old_ids = flashcard_exercises.map(&:id)

        # Old per-card attempts can't be mapped onto the new shape — they're
        # cleared rather than preserved. Fine pre-launch; would need a real
        # data-migration strategy if this ran against production data.
        ExerciseAttempt.where(exercise_id: old_ids).destroy_all
        flashcard_exercises.each(&:destroy)

        new_exercise = Exercise.create!(
          lesson_section: section,
          exercise_type: "flashcard",
          position: first_position,
          content: { "cards" => cards }
        )

        vocab_links.each do |vocabulary_item_id, position|
          new_exercise.exercise_vocabulary_items.create!(vocabulary_item_id: vocabulary_item_id, position: position)
        end

        puts "Consolidated #{cards.size} cards in LessonSection##{section.id} (#{section.title})"
      end
    end
  end
end
