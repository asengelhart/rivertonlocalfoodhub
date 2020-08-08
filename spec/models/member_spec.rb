require 'rails_helper'

RSpec.describe Member, type: :model do
  describe "#full_name=" do
    it "breaks a full name down into first and last names" do
      member = Member.new(full_name: "Cid Garlond")
      expect(member.first_name).to eq("Cid")
      expect(member.last_name).to eq("Garlond")
    end
    it "places space-separated words together in first name" do
      member = Member.new(full_name: "Billy Joe MacAllister")
      expect(member.first_name).to eq("Billy Joe")
      expect(member.last_name).to eq("MacAllister")
    end
  end
  describe "#full_name" do
    it "returns a concatenated first-and-last name when both are present separately" do
      member = Member.new(first_name: "Gaius", last_name: "van Baelsar")
      expect(member.full_name).to eq("Gaius van Baelsar")
    end
    it "overrides the full name entry if both first and last name are present" do
      member = Member.new(full_name: "Gaius van Baelsar", first_name: "Gaius", last_name: "Baelsar")
      expect(member.full_name).to eq("Gaius Baelsar")
    end
  end
  describe ".add_from_csv_file" do
    it "creates members from csv file" do
      Member.add_from_csv_file("old_orders.csv")
      expect(Member.first).not_to be_nil
    end
    it "correctly uses column information to create members" do
      Member.add_from_csv_file("old_orders.csv")
      member = Member.find_by(last_name: "Engelhart")
      expect(member.first_name).to eq("Alex")
    end
  end
end