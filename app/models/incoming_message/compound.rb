require_relative 'base'

class IncomingMessage
  class Compound < Base

    DESCRIPTION_REGEXP = %r{^-([a-zA-Z]|\/)+:\s<@[a-zA-Z0-9\.]+>\s(.+)$}

    # @param [Hash] message The message we got from slack channel.
    # @option message [String] :type.
    # @option message [String] :channel.
    # @option message [String] :user.
    # @option message [String] :text.
    # @param [Standup] standup The current standup.
    def initialize(message, standup)
      super(message, standup)

      @standup = channel.today_standups.where(user_id: reffered_user.id).first!

    rescue ActiveRecord::RecordNotFound
      raise InvalidCommandError.new("<@#{user.slack_id}> Given user is not participating in today's curry order.")
    end

    # @override
    def description
      @message['text'][DESCRIPTION_REGEXP, 2].try(:strip)
    end

    # Returns the user that was given to apply current action.
    #
    # @return [User]
    def reffered_user
      User.where(slack_id: @message['text'][/\<.*?\>/].gsub(/[<>@]/, '')).first
    end

    # Raises an error if given message isn't able to be executed.
    #
    # @raise [InvalidCommandError]
    def valid?
      if reffered_user.blank?
        raise InvalidCommandError.new("<@#{user.slack_id}> Given user does not exist in this channel.")
      end

      super
    end

  end
end
