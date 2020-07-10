class ReminderMailer < ApplicationMailer
  def reminder_mail(member_id)
    @member = Member.find_by(id: member_id)
    mail(to: @member.email, subject: ENV["REMINDER_SUBJECT"] || "Time to renew your Food Hub membership!")
  end
end
