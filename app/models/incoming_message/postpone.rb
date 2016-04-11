require_relative 'simple'

class IncomingMessage
  class Postpone < Simple

    def execute
      super

      @standup.skip!

      channel.message(I18n.t('incoming_message.skip', user: @standup.user_slack_id))
    end

    def validate!
      if !@standup.active?
        raise InvalidCommandError.new("You can only skip the order when asked.")
      elsif channel.today_standups.pending.empty?
        raise InvalidCommandError.new("You cannot skip your order because you are the last one in the stack.")
      end

      super
    end

  end
end
