# hackgt

A Rails API for a yes/no answer crowdsourcing app.

__DO NOT COMMIT FRONT END FILES HERE! THIS IS AN API REPO! PLEASE MAKE ANOTHER ONE OR ASK ME TO MAKE ANOTHER REPO FOR THE FRONT END!__

## Documentation

Nothing like some quick 6:30am documentation.

### Routes
```
            Prefix Verb URI Pattern                               Controller#Action
             users POST /users(.:format)                          users#new
users_authenticate POST /users/authenticate(.:format)             users#auth_token_initialize
    users_exchange POST /users/exchange(.:format)                 users#auth_token_exchange
                   GET  /:username/answers(.:format)              answers#show_by_user
                   GET  /:username/events(.:format)               events#show_by_user
                   GET  /:username/questions(.:format)            questions#show_by_user
                   GET  /events/:event_id(.:format)               events#show
                   GET  /events/:event_id/questions(.:format)     questions#show_by_event
            events POST /events(.:format)                         events#new
                   GET  /questions/:question_id(.:format)         questions#show
                   GET  /questions/:question_id/answers(.:format) answers#show_by_question
         questions POST /questions(.:format)                      questions#new
                   GET  /answers/:answer_id(.:format)             answers#show
           answers POST /answers(.:format)                        answers#new
```

### Making a user

Send a POST request to `/users` with the following:

- username
- email
- password
- password_confirmation

You'll get a username and auth token back.

### Auth tokens

Auth tokens are essentially "form keys" and are exchanged any time a user does some sort of POST request. If a developer wants to exchange a token any other time, send a POST request to `/users/exchange` with the following params:

- username
- auth_token

The auth token _must_ be valid for that user in order to be refreshed! If that is not the case, the user will have to log in again which happens with the (POST) `/users/authenticate` route with the following parameters:

- username
- password

You'll get back an auth token which you should embed within the page so the user can, ya know, actually do things!

### Making events

Once you have a user, you can start making events. This is done by sending the following (POST) to `/events`:

- auth_token
- name

### Fetching events

You can fetch events by either using (GET) `/events/:event_id` for an individual event or by sending a `username` to (GET) `/:username/events` to get a list of events for a username.

### Making questions

You can make questions by POSTing the following params to `/questions`:

- auth_token
- event_id
- text

### Fetching questions

You can either GET individual questions with `/questions/:question_id` or show all questions for a user with (GET) `/:username/questions` or show all questions for an event with (GET) `/event/:event_id/questions`.

### Making answers

Send the following (POST) to `/answers`:

- auth_token
- question_id
- is_yes (boolean!!!)

### Fetching answers

You can either GET individual answers with `/answers/:answer_id` or show all answers for a user with (GET) `/:username/answers` or show all answers for an event with (GET) `/event/:event_id/answers`.
