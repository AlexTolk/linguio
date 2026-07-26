require "test_helper"

class LessonsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get lesson_url(lessons(:one))
    assert_response :success
  end
end
