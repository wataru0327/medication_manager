require "test_helper"

class DoctorsControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get doctors_home_url
    assert_response :success
  end
end
