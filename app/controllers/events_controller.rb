class EventsController < ApplicationController
    def show
        if (params['event_id'].nil?)
            @events = Event.all
            render status: 200, json: { events: @events }
        else
            @event = Event.find(params['event_id'])
            return render status: 404, json: { error: 'Not found!' } if @event.nil?
            render status: 200, json: { event: @event }
        end
    end

    def show_by_user
        user = User.find_by(username: params['username'])
        return render status: 404, json: { error: 'Not found!' } if user.nil?

        @events = user.events
        render status: 200, json: { username: user.username, events: @events }
    end

    def new
        user = User.find_by(auth_token: params['auth_token'])
        return render status: 401, json: { error: 'Not authorized!' } if user.nil?

        @event = Event.new(event_params(user))
        if @event.save
            user.change_token!
            user.add_karma!('event')
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
