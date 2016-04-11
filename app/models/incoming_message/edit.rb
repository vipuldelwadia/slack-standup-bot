require_relative 'simple'

class IncomingMessage
  class Edit < Simple

    def execute
      super

      question_number = @message['text'].split('').last.try(:to_i)

      @standup.delete_answer_for(question_number)
      @standup.edit! if @standup.completed?

      channel.message(@standup.question_for_number(question_number))
    end

    def validate!
      if @standup.idle? || @standup.active?
        raise InvalidCommandError.new("<@#{user.slack_id}> You can not edit an answer before your order.")
      end

      super
    end

  end
end
