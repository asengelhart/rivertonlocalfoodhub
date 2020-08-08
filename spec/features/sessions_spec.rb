require 'rails_helper'

RSpec.describe SessionsController do
  before do
    User.destroy_all
    @user = User.create!(name: "tester", email: "test@test.com", password: "pass")
  end
  
  describe "login" do
    it "logs in a valid user" do
      visit login_path
      puts page.html
      expect(page).to have_text("Username")
      fill_in "username", with: @user.name
      fill_in "password", with: "pass"
      click_button "Submit"
      expect(current_path).to eq(home_path)
    end
  end
end