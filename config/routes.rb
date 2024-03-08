Rails.application.routes.draw do
  root "flow#start"

  get "start", to: "flow#start", as: "start"
  get "eligibility", to: "flow#eligibility", as: "eligibility"
  post "eligibility", to: "flow#check_eligibility"
  get "eligible", to: "flow#eligible", as: "eligible"
  get "ineligible", to: "flow#ineligible", as: "ineligible"
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')

  resources :employees, except: :edit

  post "finish", to: "flow#finish", as: "finish"
  post "logout", to: "sessions#destroy", as: "logout" 

  namespace :admin do
    get "", to: "login#index", as: "start" #alias for the admin start page 
    resources :employees do
      collection do
        get 'invalid'
      end
      member do
        post 'mark_as_duplicate'
      end
    end
    resources :services
    get 'duplicates', to: 'duplicates#index', as: 'duplicates'
    get 'duplicates/:primary_employee_id', to: 'duplicates#index'
    get 'duplicates/:primary_employee_id/:secondary_employee_id', to: 'duplicates#index', as: 'duplicates_primary_secondary'
  end

end
