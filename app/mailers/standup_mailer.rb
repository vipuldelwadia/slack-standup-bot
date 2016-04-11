class StandupMailer < ApplicationMailer

  helper ApplicationHelper

  # Sends an email with a report of all the standups for given Channel and Date.
  #
  # @param [Integer] channel_id The standup channel id.
  def today_report(channel_id)
    channel   = Channel.find(channel_id)
    date      = Time.zone.today
    emails    = channel.available_users.send_report.pluck(:email)
    @standups = channel.standups.by_date(date)

    return if emails.blank? || @standups.blank?

    mail to: emails.join(', '), subject: "Order for #{date.strftime('%A, %d %B, %Y')}" do |format|
      format.html
    end
  end

end
