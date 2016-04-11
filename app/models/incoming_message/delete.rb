require_relative 'simple'

class IncomingMessage
  class Delete < Simple

    def execute
      super

      @standup.delete_answer_for(@message['text'].split('').last.try(:to_i))

      channel.message('Answer deleted')
    end

    def validate!
      if @standup.idle? || @standup.active?
        raise InvalidCommandError.new("<@#{user.slack_id}> You can not delete an answer before your order.")
      end

      super
    end

  end
end
