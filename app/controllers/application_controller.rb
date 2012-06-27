class ApplicationController < ActionController::Base
  include BasicApplicationController

  protect_from_forgery

  helper_method :pl 
end
