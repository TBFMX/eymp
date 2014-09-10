require 'test_helper'

class MailerTest < ActionMailer::TestCase
  test "reset_password" do
    mail = Mailer.reset_password
    assert_equal "Reset password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "recover_password" do
    mail = Mailer.recover_password
    assert_equal "Recover password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
