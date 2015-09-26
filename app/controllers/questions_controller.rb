class QuestionsController < ApplicationController
    def show
        @question = Question.find(params['question_id'])
        return render status: 404, json: { error: 'Not found!' } if @question.nil?
        render status: 200, json: { question: @question }
    end

    def show_by_event
        event = Event.find(params['event_id'])
        return render status: 404, json: { error: 'Not found!' } if event.nil?

        @questions = event.questions
        render status: 200, json: { event: event.id, questions: @questions }
    end

    def show_by_user
        user = User.find_by(username: params['username'])
        return render status: 404, json: { error: 'Not found!' } if user.nil?

        @questions = user.questions
        render status: 200, json: { username: user.username, questions: @questions }
    end

    def new
        user = User.find_by(auth_token: params['auth_token'])
        return render status: 401, json: { error: 'Not authorized!' } if user.nil?

        event = Event.find(params['event_id'])
        return render status: 404, json: { error: 'Not found!' } if event.nil?

        @question = Question.new(question_params(event, user))
        if @question.save
            user.change_token!
            user.add_karma!('question')
            render status: 200, json: {
                question_id: @question.id,
                question_text: @question.text,
                event_id: event.id,
                event_name: event.name,
                username: user.username,
                auth_token: user.auth_token
            }
        else
            render status: 500, json: { error: 'Could not create question!' }
        end
    end

    def question_params(event, user)
        { text: params[:text], event_id: event.id, user_id: user.id }
    end
end
