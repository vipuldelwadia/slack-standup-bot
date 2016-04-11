require_relative 'compound'

class IncomingMessage
  class Skip < Compound

    def execute
      super

      if @standup.active?
        @standup.skip!

        channel.message(I18n.t('incoming_message.skip', user: @standup.user_slack_id))
      end
    end

    def validate!
      if !user.admin?
        raise InvalidCommandError.new("You don't have permission to skip this user.")
      elsif @standup.idle?
        raise InvalidCommandError.new("You need to wait until <@#{reffered_user.slack_id}> turns.")
      elsif @standup.completed?
        raise InvalidCommandError.new("<@#{reffered_user.slack_id}> has already completed their order today.")
      elsif @standup.answering?
        raise InvalidCommandError.new("<@#{reffered_user.slack_id}> is doing his/her order.")
      elsif channel.today_standups.pending.empty?
        raise InvalidCommandError.new("The order can not be skipped because is the last one in the stack.")
      end

      super
    end

  end
end
