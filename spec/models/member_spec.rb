require 'rails_helper'

RSpec.describe Member, type: :model do
  describe "#full_name=" do
    it "breaks a full name down into first and last names" do
      member1 = Member.create!
      member1.full_name = "Cid Garlond"
      expect(member1.first_name).to eq("Cid")
      expect(member1.last_name).to eq("Garlond")
    end
    it "places space-separated words together in first name" do
      member2 = Member.create!
      member2.full_name = "Mary Jo Rickardson"
      expect(member2.first_name).to eq("Mary Jo")
      expect(member2.last_name).to eq("Rickardson")
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