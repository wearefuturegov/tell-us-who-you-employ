Rails.application.routes.draw do
  root "flow#start"

  get "start", to: "flow#start", as: "start"
  get "eligibility", to: "flow#eligibility", as: "eligibility"
  post "eligibility", to: "flow#check_eligibility"

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')

  resources :employees, except: :edit

  post "finish", to: "flow#finish", as: "finish"
  
end
