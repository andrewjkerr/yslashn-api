Rails.application.routes.draw do
    # Basic user functions
    post 'users'                        => 'users#new'
    post 'users/authenticate'           => 'users#auth_token_initialize'
    post 'users/exchange'               => 'users#auth_token_exchange'

    # Objects associated with users
    get ':username/answers'             => 'answers#show_by_user'
    get ':username/events'              => 'events#show_by_user'
    get ':username/questions'           => 'questions#show_by_user'

    # Events
    get 'events/:event_id'              => 'events#show'
    get 'events/:event_id/questions'    => 'questions#show_by_event'
    post 'events'                       => 'events#new'

    # Questions
    get 'questions/:question_id'        => 'questions#show'
    get 'questions/:question_id/answers'=> 'answers#show_by_question'
    post 'questions'                    => 'questions#new'

    # Answers
    get 'answers/:answer_id'            => 'answers#show'
    post 'answers'                      => 'answers#new'
end
