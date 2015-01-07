source 'https://rubygems.org'

gem 'rails', '4.0.3'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery_mobile_rails', '~> 1.4.1' #mobile html5 framework

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'haml-rails', '~> 0.5.3' 
gem 'ipa', :git => 'git://github.com/sjmulder/ipa' #ipa and plist parsing support

group :development, :test do
  gem 'rspec-rails', '~> 2.14.2'
  gem 'guard-rspec', '~> 4.2.8'
  gem 'guard-rails', '~> 0.5.0'
  gem 'terminal-notifier-guard', '~> 1.5.3', require: false
  gem 'pry'
  gem 'pry-byebug'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

gem 'whenever', '~> 0.9.0' #cron
gem 'browser', '~> 0.4.0' #device family detection

# Required to parse apk files
gem "apktools", '~> 0.6.0'
gem "nokogiri", '~> 1.6.1'

# For uploading files
gem 'carrierwave', '0.10.0'
