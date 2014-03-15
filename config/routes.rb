Shipmate::Application.routes.draw do

  get "apps" => 'apps#index'

  get "ios_apps/:app_name" => 'ios_apps#list_app_releases', as: :list_app_releases
  get "ios_apps/:app_name/:app_release" => 'ios_apps#list_app_builds', :constraints => { :app_release => /[^\/]+/ }, as: :list_app_builds
  get "ios_apps/:app_name/:build_version/manifest" => 'ios_apps#show_build_manifest', :constraints => { :build_version => /[^\/]+/ }, as: :show_build_manifest
  get "ios_apps/:app_name/:build_version/show" => 'ios_apps#show_build', :constraints => { :build_version => /[^\/]+/ }, as: :show_build

  root 'apps#index'
end
