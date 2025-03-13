source 'https://rubygems.org'

gem 'rails', '~> 8.0.1'

gem 'bootsnap', require: false
gem 'pg', '~> 1.5', '>= 1.5.9'
gem 'puma', '>= 5.0'
gem 'rack-cors', require: 'rack/cors'
gem 'thruster', require: false
gem 'tzinfo-data', platforms: %i[ windows jruby ]

group :development, :test do
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.4'
  gem 'rspec-rails', '~> 7.1', '>= 7.1.1'
  gem 'rubocop-rails-omakase', require: false
end

group :test do
  gem 'database_cleaner', '~> 2.1'
  gem 'shoulda-matchers', '~> 6.4'
  gem 'simplecov', require: false
end
