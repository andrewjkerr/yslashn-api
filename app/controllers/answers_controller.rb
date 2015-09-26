class AnswersController < ApplicationController
    def show
        @answer = Answer.find(params['answer_id'])
        return render status: 404, json: { error: 'Not found!' } if @answer.nil?
        render status: 200, json: { answer: @answer }
    end

    def show_by_question
        question = Question.find(params['question_id'])
        return render status: 404, json: { error: 'Not found!' } if question.nil?

        @answers = question.answers
        render status: 200, json: { question_id: question.id, answers: @answers }
    end

    def show_by_user
        user = User.find_by(username: params['username'])
        return render status: 404, json: { error: 'Not found!' } if user.nil?

        @answers = user.answers
        render status: 200, json: { username: user.username, answers: @answers }
    end

    def new
        user = User.find_by(auth_token: params['auth_token'])
        return render status: 401, json: { error: 'Not authorized!' } if user.nil?

        question = Question.find(params['question_id'])
        return render status: 404, json: { error: 'Not found!' } if question.nil?

        if question.user == user
            return render status: 401, json: { error: 'You can\'t answer your own question!' }
        end

        @answer = Answer.new(answer_params(question, user))
        if @answer.save
            user.change_token!
            render status: 200, json: {
                answer_id: @answer.id,
                answer_is_yes: @answer.is_yes?,
                question_id: question.id,
                question_text: question.text,
                username: user.username,
                auth_token: user.auth_token
            }
        else
            render status: 500, json: { error: 'Could not create answer!' }
        end
    end

    def answer_params(question, user)
        { is_yes: params[:is_yes], question_id: question.id, user_id: user.id }
    end
end
