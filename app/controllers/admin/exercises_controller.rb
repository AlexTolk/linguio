module Admin
  class ExercisesController < Admin::BaseController
    before_action :set_lesson_section
    before_action :set_exercise, only: [ :show, :edit, :update, :destroy ]

    EXERCISE_TYPES = %w[flashcard matching fill_blank dialogue].freeze
    MATCHING_ROWS = 10
    FILL_BLANK_ROWS = 8
    DIALOGUE_ROWS = 12

    def show
    end

    def new
      @exercise = @lesson_section.exercises.build(
        position: next_position,
        exercise_type: params[:exercise_type]
      )
    end

    def create
      @exercise = @lesson_section.exercises.build(base_params)

      if assign_content(@exercise) && @exercise.save
        redirect_to admin_lesson_lesson_section_path(@lesson_section.lesson, @lesson_section), notice: "Exercise created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      @exercise.assign_attributes(base_params)

      if assign_content(@exercise) && @exercise.save
        redirect_to admin_lesson_lesson_section_path(@lesson_section.lesson, @lesson_section), notice: "Exercise updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @exercise.destroy
      redirect_to admin_lesson_lesson_section_path(@lesson_section.lesson, @lesson_section), notice: "Exercise deleted."
    end

    private

    def set_lesson_section
      @lesson_section = LessonSection.find(params[:lesson_section_id])
    end

    def set_exercise
      @exercise = @lesson_section.exercises.find(params[:id])
    end

    def base_params
      params.require(:exercise).permit(:exercise_type, :position)
    end

    def assign_content(exercise)
      case exercise.exercise_type
      when "flashcard"  then assign_flashcard_content(exercise)
      when "matching"   then assign_matching_content(exercise)
      when "fill_blank" then assign_fill_blank_content(exercise)
      when "dialogue"   then assign_dialogue_content(exercise)
      else assign_raw_json_content(exercise)
      end
    end

    def assign_flashcard_content(exercise)
      content = params.require(:exercise)
                       .fetch(:content, {})
                       .permit(front: [ :word ], back: [ :translation, :example ])
      exercise.content = content.to_h
      true
    end

    def assign_matching_content(exercise)
      raw = params.dig(:exercise, :content, :pairs)&.to_unsafe_h || {}

      pairs = raw.values.filter_map do |row|
        left = row["left"].to_s.strip
        right = row["right"].to_s.strip
        { "left" => left, "right" => right } if left.present? || right.present?
      end

      exercise.content = { "pairs" => pairs }
      true
    end

    def assign_fill_blank_content(exercise)
      raw = params.dig(:exercise, :content, :questions)&.to_unsafe_h || {}

      questions = raw.values.filter_map do |row|
        sentence = row["sentence"].to_s.strip
        answer = row["answer"].to_s.strip
        hint = row["hint"].to_s.strip
        alternatives = row["alternatives"].to_s.split(",").map(&:strip).reject(&:blank?)
        alternatives = [ answer ] if alternatives.empty? && answer.present?

        next if sentence.blank? && answer.blank?

        { "sentence" => sentence, "answer" => answer, "alternatives" => alternatives, "hint" => hint }
      end

      exercise.content = { "questions" => questions }
      true
    end

    def assign_dialogue_content(exercise)
      raw = params.dig(:exercise, :content, :lines)&.to_unsafe_h || {}

      lines = raw.values.filter_map do |row|
        type = row["type"].presence || "shown"
        speaker = row["speaker"].to_s.strip

        case type
        when "choice"
          option_a_text = row["option_a_text"].to_s.strip
          option_b_text = row["option_b_text"].to_s.strip
          next if speaker.blank? && option_a_text.blank? && option_b_text.blank?

          correct = row["correct_option"]

          {
            "type" => "choice",
            "speaker" => speaker,
            "options" => [
              { "text" => option_a_text, "translation" => row["option_a_translation"].to_s.strip, "correct" => correct == "a" },
              { "text" => option_b_text, "translation" => row["option_b_translation"].to_s.strip, "correct" => correct == "b" }
            ]
          }
        else
          text = row["text"].to_s.strip
          next if speaker.blank? && text.blank?

          { "type" => "shown", "speaker" => speaker, "text" => text, "translation" => row["translation"].to_s.strip }
        end
      end

      exercise.content = { "lines" => lines }
      true
    end

    def assign_raw_json_content(exercise)
      raw = params.require(:exercise)[:content_json].to_s
      @content_json_raw = raw

      if raw.strip.empty?
        exercise.content = {}
        return true
      end

      exercise.content = JSON.parse(raw)
      true
    rescue JSON::ParserError => e
      exercise.errors.add(:content, "is not valid JSON — #{e.message}")
      false
    end

    def next_position
      (@lesson_section.exercises.maximum(:position) || 0) + 1
    end
  end
end
