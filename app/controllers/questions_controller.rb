class QuestionsController < ApplicationController
    def new
        user = User.find_by(auth_token: params['auth_token'])
        return render status: 401, json: { error: 'Not authorized!' } if user.nil?

        event = Event.find(params['event_id'])
        return render status: 404, json: { error: 'Not found!' } if event.nil?

        @question = Question.new(question_params(event, user))
        if @question.save
            user.change_token!
            render status: 200, json: {
                question_id: @question.id,
                question_text: @question.text,
                event_id: event.id,
                event_name: event.name,
                username: user.username,
                auth_token: user.auth_token
            }
        else
            render status: 500, json: { error: 'Could not create event!' }
        end
    end

    def question_params(event, user)
        { text: params[:text], event_id: event.id, user_id: user.id }
    end
end
