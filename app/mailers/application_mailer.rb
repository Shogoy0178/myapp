# frozen_string_literal: true

# メール送信の基底クラス
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
