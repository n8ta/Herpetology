require Rails.root.join('app','mailers','application_mailer.rb')
class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: "Welcome to HerpID")
  end
end
