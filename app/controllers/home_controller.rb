# frozen_string_literal: true

# ホーム画面のコントローラ
class HomeController < ApplicationController
  # ログインチェックを行わない
  skip_before_action :require_login, only: [:top] # ログインしなくてもアクセスできるように設定

  def top; end
end
