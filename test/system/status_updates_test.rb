require "application_system_test_case"

class StatusUpdatesTest < ApplicationSystemTestCase
  setup do
    @status_update = status_updates(:one)
  end

  test "visiting the index" do
    visit status_updates_url
    assert_selector "h1", text: "Status updates"
  end

  test "should create status update" do
    visit status_updates_url
    click_on "New status update"

    fill_in "Pharmacy", with: @status_update.pharmacy_id
    fill_in "Prescription", with: @status_update.prescription_id
    fill_in "Status", with: @status_update.status
    click_on "Create Status update"

    assert_text "Status update was successfully created"
    click_on "Back"
  end

  test "should update Status update" do
    visit status_update_url(@status_update)
    click_on "Edit this status update", match: :first

    fill_in "Pharmacy", with: @status_update.pharmacy_id
    fill_in "Prescription", with: @status_update.prescription_id
    fill_in "Status", with: @status_update.status
    click_on "Update Status update"

    assert_text "Status update was successfully updated"
    click_on "Back"
  end

  test "should destroy Status update" do
    visit status_update_url(@status_update)
    click_on "Destroy this status update", match: :first

    assert_text "Status update was successfully destroyed"
  end
end
