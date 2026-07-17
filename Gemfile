source 'https://rubygems.org'

ruby '3.2.2'

gem 'rails', '~> 7.1.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.0'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt', '~> 2.7'
gem 'rack-cors'
gem 'kaminari', '~> 1.2'
gem 'rswag-api'
gem 'rswag-ui'
gem 'jbuilder'
gem 'active_model_serializers', '~> 0.10.0'
gem 'dotenv-rails', groups: [:development, :test]

gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'bootsnap', require: false

group :development, :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rswag-specs'
  gem 'debug', platforms: %i[mri windows]
end

group :development do
  gem 'annotate'
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
  gem 'database_cleaner-active_record'
end
