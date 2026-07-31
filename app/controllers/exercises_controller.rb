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

    next_exercise = @exercise.next_exercise

    if next_exercise
      redirect_to lesson_lesson_section_exercise_path(
        next_exercise.lesson, next_exercise.lesson_section, next_exercise
      )
    else
      redirect_to @lesson, notice: "Lesson complete!"
    end
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
    @lesson_section = @exercise.lesson_section
    @lesson = @exercise.lesson
  end

  def compute_score
    case @exercise.exercise_type
    when "flashcard"
      { score: params[:known] == "true" ? 100 : 0, answers: [] }
    when "matching"
      score_matching
    when "fill_blank"
      score_fill_blank
    when "dialogue"
      # No comprehension questions yet — full credit for completing the
      # read-through. Swap this for real scoring once questions exist.
      { score: 100, answers: [] }
    else
      raise ArgumentError, "Unknown exercise_type: #{@exercise.exercise_type}"
    end
  end

  def score_matching
    pairs = @exercise.content["pairs"]
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

    score = ((answers.count { |a| a[:correct] }.to_f / answers.size) * 100).round
    { score: score, answers: answers }
  end

  def score_fill_blank
    questions = @exercise.content["questions"]
    submitted = params[:answers] || {}

    answers = questions.each_with_index.map do |q, i|
      given = submitted[i.to_s].to_s.strip
      acceptable = ([q["answer"]] + Array(q["alternatives"])).compact.map { |a| a.strip.downcase }
      correct = acceptable.include?(given.downcase)

      {
        item_key: i.to_s,
        given_answer: given,
        correct_answer: q["answer"],
        correct: correct
      }
    end

    score = ((answers.count { |a| a[:correct] }.to_f / answers.size) * 100).round
    { score: score, answers: answers }
  end
end