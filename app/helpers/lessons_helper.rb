module LessonsHelper
  def lesson_state(lesson, user)
    return :completed if lesson.completed_by?(user)
    return :in_progress if lesson.score_for(user).present?
    :not_started
  end

  def lesson_button_text(state)
    { completed: "Review", in_progress: "Continue →", not_started: "Start" }.fetch(state)
  end

  def lesson_button_variant(state)
    state == :in_progress ? :primary : :secondary
  end

  def section_state(section, current_section, user)
    return :current if section == current_section
    section.completed_by?(user) ? :completed : :upcoming
  end
end
