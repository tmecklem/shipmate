source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery_mobile_rails', '~> 1.4.1' #mobile html5 framework

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~>2.2.1'

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
  gem 'debugger', '~> 1.6.6'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

gem 'whenever', '~> 0.9.0' #cron
gem 'browser', '~> 0.4.0' #device family detection

# Required to parse apk files
gem "apktools", '~> 0.6.0'

# Required to parse docs
gem "nokogiri", '~> 1.6.1'

# For uploading files
gem 'carrierwave', '0.10.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development