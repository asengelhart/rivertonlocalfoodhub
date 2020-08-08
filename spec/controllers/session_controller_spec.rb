require 'rails_helper'

RSpec.describe SessionsController do
  before do
    User.destroy_all
    @user = User.create!(name: "tester", email: "test@test.com", password: "pass")
  end

  describe "new" do
    it "displays a login screen" do
      get :new
      expect(response).to render_template(:new)
    end
  end
end