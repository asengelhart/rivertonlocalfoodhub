require 'rails_helper'

RSpec.describe SessionsController do
  before do
    User.destroy_all
    User.create!(name: "tester", email: "test@test.com", password: "pass")
  end

  describe "new" do
    it "displays a login screen" do
      visit "/login"
      expect(page).to have_content("Password")
    end

    it "logs in a valid user" do
      visit "/login"
      fill_in "email", with: @user.name
      fill_in "password", with: "pass"
      click_button "Submit"
      expect(current_path).to eq(home_path)
    end
  end
end