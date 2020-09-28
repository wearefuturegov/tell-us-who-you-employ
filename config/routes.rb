Rails.application.routes.draw do
  root "flow#start"
  get "start", to: "flow#start", as: "start"
  get "eligibility", to: "flow#eligibility", as: "eligibility"
  post "eligibility", to: "flow#check_eligibility"
  get "confirmation", to: "flow#confirmation", as: "confirmation"
  resources :employees, except: :edit
end
