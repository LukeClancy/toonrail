source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
#using postgresql
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# throw in someathat image_magick cause actiontext broke.
# lmao curveball run a "apt-get install imagemagick' for some sick ass binaries
# that should probably of been included in the package allready lmao yaassssss binaries!
# have fun with that docker install biiiiiiiiitttttttttttc*

gem 'image_magick'

#comments and likes dependancies
gem 'acts_as_commentable'
gem 'acts_as_votable'

#Bootstrap front end formatting
gem 'jquery-rails'
gem 'bootstrap', '~> 4.5.0'

#file upload and download (works well with above)
gem 'carrierwave'

# better view coding language
gem 'haml-rails'

# user authentication and security
gem 'devise'
# devise omniauth 
gem 'omniauth'
#gem 'omniauth-github'
#gem 'omniauth-facebook'

#we are using summernote instead of trix rich text because trix UI is trash lmao
gem 'simple_form'
gem 'summernote-rails', '~> 0.8.12.0'

#sudo apt install ruby-dev
#sudo apt install postgresql
#sudo apt install libpq-dev
#sudo apt install nodejs
#https://classic.yarnpkg.com/en/docs/install/#debian-stable
#or i guess use a rails docker image, note that you still need the imagemagick apt above

gem 'coffee-script', '~> 2.4', '>= 2.4.1'
