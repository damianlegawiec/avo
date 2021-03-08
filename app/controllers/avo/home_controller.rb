require_dependency 'avo/application_controller'

module Avo
  class HomeController < ApplicationController
    def index
      unless Rails.env.development?
        redirect_to resources_path Avo::App.get_resources.sort_by { |resource| resource.route_key }.first.model_class
      end
    end
  end
end
