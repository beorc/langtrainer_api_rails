# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'approvals/rspec'
require 'cranky'
require 'factories/users'
require 'factories/courses'
require 'factories/units'
require 'factories/steps'
require 'factories/trainings'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Automigrate if needs migration
if ActiveRecord::Migrator.needs_migration?
  ActiveRecord::Migrator.migrate(File.join(Rails.root, 'db/migrate'))
end

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

DatabaseCleaner.logger = Rails.logger
Cranky::Factory.include RSpec::ActiveModel::Mocks::Mocks

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # This says that before the entire test suite runs, clear the test database out completely.
  # This gets rid of any garbage left over from interrupted or poorly-written tests—a
  # common source of surprising test behavior.
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # This part sets the default database cleaning strategy to be transactions.
  # Transactions are very fast, and for all the tests where they do work—that is,
  # any test where the entire test runs in the RSpec process—they are preferable.
  config.before(:example) do
    DatabaseCleaner.strategy = :transaction
  end

  # This line only runs before examples which have been flagged :js => true.
  # By default, these are the only tests for which Capybara fires up a test
  # server process and drives an actual browser window via the Selenium backend.
  # For these types of tests, transactions won’t work, so this code overrides the
  # setting and chooses the “truncation” strategy instead.
  config.before(:example, type: 'feature') do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
