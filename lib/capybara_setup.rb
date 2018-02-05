require "capybara"
# require "capybara/dsl"
require "selenium-webdriver"

TMP_DIR = Dir.tmpdir

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_preference("download.default_directory", TMP_DIR)
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.default_driver = :selenium
Capybara.default_max_wait_time = 5

class LoginFailedError < StandardError
end
