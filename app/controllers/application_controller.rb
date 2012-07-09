class ApplicationController < ActionController::Base
  include BasicApplicationController

  rescue_from Exception do |ex|
    ErrorMailer.error_log(ex).deliver
  end

  protect_from_forgery

  helper_method :pl 
end
