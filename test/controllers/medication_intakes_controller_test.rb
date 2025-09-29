require "test_helper"

class MedicationIntakesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get medication_intakes_create_url
    assert_response :success
  end

  test "should get destroy" do
    get medication_intakes_destroy_url
    assert_response :success
  end
end
