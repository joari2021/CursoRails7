Rails.application.routes.draw do
  get "products/new", to: "products#new", as: :new_product
  post "/products", to: "products#create"
  get "products/:id/edit", to: "products#edit", as: :edit_product
  get "/products", to: "products#index"
  get "/products/:id", to: "products#show", as: :product
  patch "/products/:id", to: "products#update"
end
