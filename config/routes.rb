Rails.application.routes.draw do
  root "employees#index"
  resources :employees, except: :edit
end
