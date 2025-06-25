require "rails_helper"

RSpec.describe "User Authentication", type: :system do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }

  it "allows a user to sign in" do
    visit new_user_session_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
  end

  it "does not allow login with invalid credentials" do
    visit new_user_session_path
    fill_in "Email", with: "wrong@example.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_content("Invalid Email or password")
  end
end
