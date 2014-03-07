$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV["RAILS_ENV"] = "test"
require 'simplecov'
require 'coveralls'
Coveralls.wear! 'rails'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'shoulda'
require 'capybara/rails'
require 'database_cleaner'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

DatabaseCleaner.strategy = :truncation

Warden.test_mode!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Warden::Test::Helpers

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false
  
  def admin_login_as(admin_user = Factory(:admin_user))
    visit '/admin/login'
    fill_in 'admin_user_email', :with => admin_user.email
    fill_in 'admin_user_password', :with => 'BaudP0wer!'
    click_button 'Login'
  end

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end
end

class AdminControllerTestCase < ActionController::TestCase
  include Devise::TestHelpers
  include Warden::Test::Helpers

  def admin_login_as(admin_user = Factory(:admin_user))
    request.env["devise.mapping"] = Devise.mappings[:admin_user]
    sign_in admin_user
    admin_user
  end
end
