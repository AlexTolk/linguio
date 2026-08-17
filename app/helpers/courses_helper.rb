module CoursesHelper
  def course_progress(course, user)
    lessons = course.course_sections.order(:position).flat_map { |s| s.lessons.order(:position) }
    completed = lessons.count { |l| l.completed_by?(user) }
    total = lessons.size
    pct = total.zero? ? 0 : ((completed.to_f / total) * 100).round
    [ completed, total, pct ]
  end

  # The section to auto-expand by default: the first one with incomplete lessons,
  # or the last section if everything is done.
  def default_open_section(course, user)
    sections = course.course_sections.order(:position)
    sections.find { |s| s.lessons.order(:position).any? { |l| !l.completed_by?(user) } } || sections.last
  end
end
