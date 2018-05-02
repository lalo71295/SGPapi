Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :permissions
  resources :tasks
  resources :classifications
  resources :configs
  resources :departments
  resources :cities
  resources :states
  resources :employees_projects_rols
  resources :companies
  devise_for :users, :controllers => { :sessions => "custom_sessions" }

  resources :users
  resources :milestones
  resources :incomes
  resources :projects_rols
  resources :projects
  resources :concepts
  resources :costs
  resources :rols
  resources :employees
  resources :hours_employee
end
