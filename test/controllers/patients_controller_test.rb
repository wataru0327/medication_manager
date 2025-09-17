require "test_helper"

class PatientsControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get patients_home_url
    assert_response :success
  end
end
