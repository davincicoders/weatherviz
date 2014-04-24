# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'
require 'vcr'

# 'vcr' gem configuration
# https://www.relishapp.com/vcr/vcr/v/2-2-5/docs/test-frameworks/usage-with-rspec-metadata
# http://railscasts.com/episodes/291-testing-with-vcr?view=comments
VCR.configure do |c|
  c.cassette_library_dir  = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { :record => :new_episodes, :erb => true }
  c.filter_sensitive_data('<OpenWeatherMapAPIKey>') { ENV['OPENWEATHER_APPID'] }
  c.allow_http_connections_when_no_cassette = true
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # 'vcr' gem related configuration
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    VCR.use_cassette(name) { example.call }
  end
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # This will save you the trouble of the prefixing FactoryGirl before :build
  # and :create
  config.include FactoryGirl::Syntax::Methods
end
