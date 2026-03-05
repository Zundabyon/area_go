Rails.application.routes.draw do
  # PWA
  get "manifest"       => "rails/pwa#manifest",       as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # 認証
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions:      "users/sessions"
  }

  # ルート
  root "dashboard#index"
  get "dashboard", to: "dashboard#index", as: :dashboard

  # 施設
  resources :facilities, only: [ :index, :show, :new, :create ] do
    collection do
      get :search
    end
  end

  # ルアー
  resources :lures do
    member do
      get :catch_records
    end
  end

  # 釣果
  resources :catch_records do
    collection do
      get :map
    end
  end

  # プロフィール
  namespace :users do
    resource :profile, only: [ :show, :edit, :update ]
  end
end
