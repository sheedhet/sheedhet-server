class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
# class ApplicationController < ActionController::API
  # include ActionController::Serialization
