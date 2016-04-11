require_relative 'compound'

class IncomingMessage
  class NotAvailable < Compound

    def execute
      super

      if @standup.active?
        @standup.update_column(:reason, description)
        @standup.not_available!

        channel.message("<@#{reffered_user.slack_id}> is not available.")
      end
    end

    def validate!
      if !user.admin?
        raise InvalidCommandError.new("You don't have permission to set this user not available.")
      elsif @standup.idle?
        raise InvalidCommandError.new("You need to wait until <@#{reffered_user.slack_id}> turns.")
      elsif @standup.completed?
        raise InvalidCommandError.new("<@#{reffered_user.slack_id}> has already completed their order for today.")
      elsif @standup.answering?
        raise InvalidCommandError.new("<@#{reffered_user.slack_id}> is doing his/her order.")
      end

      super
    end

  end
end
