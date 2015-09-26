class EventsController < ApplicationController
    def new
        user = User.find_by(auth_token: params['auth_token'])
        return render status: 401, json: { error: 'Not authorized!' } if user.nil?

        @event = Event.new(event_params(user))
        if @event.save
            user.change_token!
            render status: 200, json: { 
                event_id: @event.id,
                event_name: @event.name,
                username: user.username,
                auth_token: user.auth_token
            }
        else
            render status: 500, json: { error: 'Could not create event!' }
        end
    end

    def event_params(user)
        { name: params[:name], user_id: user.id }
    end
end
