class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise

  def show
  end

  def submit
    result = compute_score
    attempt = nil

    ActiveRecord::Base.transaction do
      attempt = current_user.exercise_attempts.create!(
        exercise: @exercise,
        status: :completed,
        score: result[:score],
        completed_at: Time.current
      )

      result[:answers].each { |a| attempt.exercise_attempt_answers.create!(a) }
    end

    redirect_to result_lesson_lesson_section_exercise_path(
      @lesson, @lesson_section, @exercise, attempt_id: attempt.id
    )
  end

  def result
    @attempt = @exercise.exercise_attempts.for_user(current_user).find(params[:attempt_id])
  end
  def review
    @attempt = @exercise.exercise_attempts.for_user(current_user).lesson.order(completed_at: :desc).first
    @item_keys = @attempt&.exercise_attempt_answers&.where(correct: false)&.pluck(:item_key) || []

    redirect_to lesson_lesson_section_exercise_path(@lesson, @lesson_section, @exercise) and return if @item_keys.empty?
  end

  def submit_review
    last_lesson_attempt = @exercise.exercise_attempts.for_user(current_user).lesson.order(completed_at: :desc).first
    item_keys = last_lesson_attempt&.exercise_attempt_answers&.where(correct: false)&.pluck(:item_key) || []
    result = compute_score(item_keys: item_keys)
    attempt = nil

    ActiveRecord::Base.transaction do
      attempt = current_user.exercise_attempts.create!(
        exercise: @exercise,
        status: :completed,
        score: result[:score],
        completed_at: Time.current,
        context: :review
      )

      result[:answers].each { |a| attempt.exercise_attempt_answers.create!(a) }
    end

    redirect_to result_lesson_lesson_section_exercise_path(
      @lesson, @lesson_section, @exercise, attempt_id: attempt.id
    )
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
    @lesson_section = @exercise.lesson_section
    @lesson = @exercise.lesson
  end

  def compute_score(item_keys: nil)
    case @exercise.exercise_type
    when "flashcard"
      { score: params[:known] == "true" ? 100 : 0, answers: [] }
    when "matching"
      score_matching(item_keys: item_keys)
    when "fill_blank"
      score_fill_blank(item_keys: item_keys)
    when "dialogue"
      score_dialogue
    else
      raise ArgumentError, "Unknown exercise_type: #{@exercise.exercise_type}"
    end
  end

  def score_matching(item_keys: nil)
    pairs = @exercise.content["pairs"]
    pairs = pairs.select { |p| item_keys.include?(p["left"]) } if item_keys.present?
    submitted = params[:matches] || {}

    answers = pairs.map do |pair|
      given = submitted[pair["left"]]
      {
        item_key: pair["left"],
        given_answer: given,
        correct_answer: pair["right"],
        correct: given == pair["right"]
      }
    end

    score = answers.any? ? ((answers.count { |a| a[:correct] }.to_f / answers.size) * 100).round : 0
    { score: score, answers: answers }
  end

  def score_fill_blank(item_keys: nil)
    questions = @exercise.content["questions"]
    questions = questions.each_with_index.select { |_q, i| item_keys.include?(i.to_s) }.map(&:first) if item_keys.present?
    submitted = params[:answers] || {}

    answers = questions.each_with_index.map do |q, i|
      given = submitted[i.to_s].to_s.strip
      acceptable = ([ q["answer"] ] + Array(q["alternatives"])).compact.map { |a| a.strip.downcase }
      correct = acceptable.include?(given.downcase)

      {
        item_key: i.to_s,
        given_answer: given,
        correct_answer: q["answer"],
        correct: correct
      }
    end

    score = if answers.any?
      ((answers.count { |a| a[:correct] }.to_f / answers.size) * 100).round
    else
      0
    end

    { score: score, answers: answers }
  end

  def score_dialogue
    lines = @exercise.content["lines"]
    submitted = params[:choices] || {}

    gradable_lines = lines.each_with_index.select { |line, _i| line["options"].present? }

    answers = gradable_lines.map do |line, i|
      options = line["options"]
      given_index = submitted[i.to_s]
      given_option = given_index.present? ? options[given_index.to_i] : nil
      correct_option = options.find { |o| o["correct"] }

      {
        item_key: i.to_s,
        given_answer: given_option&.fetch("text", nil),
        correct_answer: correct_option&.fetch("text", nil),
        correct: given_option == correct_option
      }
    end

    score = if answers.any?
      ((answers.count { |a| a[:correct] }.to_f / answers.size) * 100).round
    else
      0
    end

    { score: score, answers: answers }
  end
end
