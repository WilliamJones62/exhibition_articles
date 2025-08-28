# frozen_string_literal: true

# This class contains Application mailer logic
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
