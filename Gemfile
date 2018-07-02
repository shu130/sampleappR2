source 'https://rubygems.org'

gem 'rails',        '5.1.4'
gem 'slim-rails',   '3.1.3'   # slim を使用

gem 'bcrypt',       '3.1.11'
gem 'puma',         '3.9.1'

# gem 'faker',        '1.7.3'

# 画像投稿
gem 'carrierwave',             '1.1.0'
gem 'mini_magick',             '4.7.0'
gem 'fog',                     '1.40.0'

gem 'will_paginate',           '3.1.5'
gem 'bootstrap-will_paginate', '1.0.0'

# Bootstrap3
gem 'sass-rails',   '5.0.6'
gem 'bootstrap-sass', '3.3.7'

gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'

# gem 'rake', '< 11.0'
gem 'rake', '12.3.1'

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug',  '9.0.6', platform: :mri  # debuggerメソッド用

  # rspec

  # gem "rspec-rails", "~> 3.1.0"
  # gem "rspec-rails"
  # gem "factory_girl_rails", "~> 4.4.1"

  gem "faker"
  gem 'rspec-rails', '~> 3.7.2'
  gem "factory_bot_rails"
  gem 'spring-commands-rspec'
  gem 'rspec-its'
  gem "database_cleaner"
end

group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.0.8'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'annotate'
  gem 'hirb'         # モデルの出力結果を表形式で表示するGem
  gem 'hirb-unicode' # 日本語などマルチバイト文字の出力時の出力結果のずれに対応
end

# rspec
group :test do
  # gem "faker", "~> 1.4.3"
  # gem "faker"
  gem 'capybara', '~> 2.15.2'
  # gem "database_cleaner", "~> 1.3.0"
  # gem "database_cleaner"
  gem "launchy", "~> 2.4.2"
  gem "selenium-webdriver", "~> 2.43.0"

  gem 'shoulda-matchers',
    git: 'https://github.com/thoughtbot/shoulda-matchers.git',
    branch: 'rails-5'

  # gem 'shoulda-matchers', '2.7.0'
  # gem 'shoulda-matchers', '~> 3.1'
end

# minitest
group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  gem 'pg', '0.18.4'
end
