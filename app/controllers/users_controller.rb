class UsersController < ApplicationController
    def new
        @user = User.new(user_params)
        if @user.save
            @user.change_token!
            render status: 200, json: { username: @user.username, auth_token: @user.auth_token }
        else
            render status: 500, json: { error: 'Could not create user!' }
        end
    end

    def auth_token_initialize
        user = User.find_by(username: params['username'])
        return render status: 404, json: { error: 'Not found!' } if user.nil?

        if (user.authenticate(params['password']))
            user.change_token!
            render status: 200, json: { username: user.username, auth_token: user.auth_token }
        else
            render status: 401, json: { error: 'Not authorized!' }
        end
    end

    def auth_token_exchange
        user = User.find_by(username: params['username'])
        return render status: 404, json: { error: 'Not found!' } if user.nil?

        if (user.auth_token == params['auth_token'])
            user.change_token!
            render status: 200, json: { username: user.username, auth_token: user.auth_token }
        else
            render status: 401, json: { error: 'Not authorized!' }
        end
    end

    def user_params
        params.permit(:username, :email, :password, :password_confirmation)
    end
end
