# Preview all emails at http://localhost:3000/rails/mailers/mailer
class MailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/mailer/reset_password
  def reset_password
    Mailer.reset_password
  end

  # Preview this email at http://localhost:3000/rails/mailers/mailer/recover_password
  def recover_password
    Mailer.recover_password
  end

end
