Rails.application.routes.draw do
    post 'users' => 'users#new'
    post 'users/authenticate' => 'users#auth_token_initialize'
    post 'users/exchange' => 'users#auth_token_exchange'

    post 'events' => 'events#new'

    post 'questions' => 'questions#new'

    post 'answers' => 'answers#new'
end
