module ResultsHelper
  def section_result_rows(section, user)
    section.exercises.order(:position).map do |exercise|
      attempt = exercise.exercise_attempts.for_user(user).completed.lesson
                         .order(completed_at: :desc).first
      { exercise: exercise, answers: attempt&.exercise_attempt_answers || [] }
    end
  end

  # Flashcard prompt/translation lookups
  def flashcard_word(exercise, answer)
    exercise.content.dig("cards", answer.item_key.to_i, "front", "word") || answer.item_key
  end

  def flashcard_translation(exercise, answer)
    exercise.content.dig("cards", answer.item_key.to_i, "back", "translation")
  end

  # Fill-blank: splice the given/correct answer inline into the original sentence
  def fill_blank_inline_sentence(exercise, answer)
    question = exercise.content.dig("questions", answer.item_key.to_i)
    return answer.item_key unless question

    before, after = question["sentence"].split("___", 2)
    after ||= ""

    filled = if answer.correct?
      content_tag(:span, answer.correct_answer, class: "text-success-700 font-semibold")
    else
      content_tag(:span, answer.given_answer.presence || "—", class: "text-accent-700 line-through") +
        " ".html_safe +
        content_tag(:span, answer.correct_answer, class: "text-success-700 font-semibold")
    end

    safe_join([ before, filled, after ])
  end

  # Dialogue: walk every line in order, pairing scored response lines with their answer
  def dialogue_transcript_rows(exercise, answers)
    answers_by_key = answers.index_by(&:item_key)

    exercise.content["lines"].each_with_index.map do |line, i|
      if line["options"].blank?
        { type: :context, speaker: line["speaker"], text: line["text"] }
      else
        { type: :response, speaker: line["speaker"], answer: answers_by_key[i.to_s] }
      end
    end
  end
end
