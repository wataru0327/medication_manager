require_relative "boot"

require "rails/all"

# ✅ dotenv を読み込む（開発・テスト環境でのみ）
require 'dotenv/load' if %w[development test].include? ENV['RAILS_ENV']

Bundler.require(*Rails.groups)

module MedicationManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # lib配下のオートロード設定
    config.autoload_lib(ignore: %w(assets tasks))

    # -----------------------------
    # 日本語化設定を追加
    # -----------------------------
    config.i18n.default_locale = :ja   # デフォルトを日本語に
    config.i18n.available_locales = [:en, :ja]  # 利用可能な言語
    config.time_zone = 'Tokyo'         # タイムゾーンを日本に
  end
end
