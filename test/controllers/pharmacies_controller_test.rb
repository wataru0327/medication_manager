require "test_helper"

class PharmaciesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pharmacies_home_url
    assert_response :success
  end
end
