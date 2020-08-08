require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#new" do
    it "creates a user with a username and password" do
      user = User.new(name: "User", password: "Pass")
      digest = user.password_digest
      expect(digest).not_to be_nil
      expect(digest).not_to eq("Pass")
    end

    it "authenticates a user" do
      user = User.new(name: "User", password: "Pass")
      authenticated = user.authenticate("Pass")
      not_authenticated = user.authenticate("wrong")
      expect(authenticated).to eq(user)
      expect(not_authenticated).to eq(false)
    end
  end
end