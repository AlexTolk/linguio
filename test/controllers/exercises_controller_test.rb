require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    sign_in users(:one)
    get lesson_lesson_section_exercise_url(lessons(:one), lesson_sections(:one), exercises(:one))
    assert_response :success
  end
end
