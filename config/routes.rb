Rails.application.routes.draw do
  root to: "home#index"
  
  get "yesterday" => "home#yesterday"
end
