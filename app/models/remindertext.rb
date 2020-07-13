class Remindertext < ApplicationRecord
  def insert_member(member_id)
    member = Member.find_by(id: member_id)
    return self.text unless member
    newtext = self.text.gsub(/<(\S+)>/) do |match|
      tag = self.send(match[1].to_sym)
      tag if tag else match.string
    end
  end
end