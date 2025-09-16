require "application_system_test_case"

class PrescriptionsTest < ApplicationSystemTestCase
  setup do
    @prescription = prescriptions(:one)
  end

  test "visiting the index" do
    visit prescriptions_url
    assert_selector "h1", text: "Prescriptions"
  end

  test "should create prescription" do
    visit prescriptions_url
    click_on "New prescription"

    fill_in "Doctor", with: @prescription.doctor_id
    fill_in "Expires at", with: @prescription.expires_at
    fill_in "Issued at", with: @prescription.issued_at
    fill_in "Patient", with: @prescription.patient_id
    fill_in "Qr token", with: @prescription.qr_token
    click_on "Create Prescription"

    assert_text "Prescription was successfully created"
    click_on "Back"
  end

  test "should update Prescription" do
    visit prescription_url(@prescription)
    click_on "Edit this prescription", match: :first

    fill_in "Doctor", with: @prescription.doctor_id
    fill_in "Expires at", with: @prescription.expires_at
    fill_in "Issued at", with: @prescription.issued_at
    fill_in "Patient", with: @prescription.patient_id
    fill_in "Qr token", with: @prescription.qr_token
    click_on "Update Prescription"

    assert_text "Prescription was successfully updated"
    click_on "Back"
  end

  test "should destroy Prescription" do
    visit prescription_url(@prescription)
    click_on "Destroy this prescription", match: :first

    assert_text "Prescription was successfully destroyed"
  end
end
