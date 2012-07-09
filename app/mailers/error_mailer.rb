class ErrorMailer < ActionMailer::Base
  default from: "from@example.com"

  def error_log
    mail(:to => "jsveholm@fir.riec.tohoku.ac.jp", :subject => "ldap_reloaded::Error")
  end
end
