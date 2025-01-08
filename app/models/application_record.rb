# frozen_string_literal: true

# モデルの基底クラス
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
