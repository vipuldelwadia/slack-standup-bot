require_relative 'simple'

class IncomingMessage
  class Unavailable < Simple

    def execute
      super

      if @standup.active?
        @standup.update_column(:reason, description)
        @standup.not_available!

        channel.message("<@#{user.slack_id}> is not available.")
      end
    end

    def validate!
      if !@standup.active?
        raise InvalidCommandError.new("You need to wait until your turn.")
      elsif @standup.completed?
        raise InvalidCommandError.new("You've already completed your order for today.")
      end

      super
    end

  end
end
