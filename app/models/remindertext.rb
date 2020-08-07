class Remindertext < ApplicationRecord
  def insert_member(member_input)
    if member_input.is_a? Integer
      member = Member.find_by(id: member_id)
    elsif member_input.is_a? Member
      member = member_input
    end
    return "Member not found" unless member
    self.text.gsub(/<(\S+)>/) do |match|
      begin
        tag = member.send($1.to_sym)
      rescue NoMethodError
        tag = match
      end
      tag
    end
  end
end
