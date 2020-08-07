require 'rails_helper'

RSpec.describe Remindertext, :model do
  it "substitutes text in brackets for a member's matching attribute" do
    text = Remindertext.new(text: "First: <first_name> Last: <last_name>")
    member = Member.new(first_name: "Jimmy", last_name: "Buffet")
    expect(text.insert_member(member)).to eq("First: Jimmy Last: Buffet")
  end

  it "returns unaltered tags when said tag contains an invalid attribute" do
    text = Remindertext.new(text: "First: <first_name> Last: <bleegablarg>")
    member = Member.new(first_name: "Jimmy", last_name: "Buffet")
    expect(text.insert_member(member)).to eq("First: Jimmy Last: <bleegablarg>")
  end
end
