require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get course_url(1)
    assert_response :success
  end

  test "should get show" do
    get courses_show_url
    assert_response :success
  end
end
