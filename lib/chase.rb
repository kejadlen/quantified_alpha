#!/usr/bin/env ruby

require "capybara"
require "capybara/dsl"
require "selenium-webdriver"

TMP_DIR = Dir.tmpdir

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_preference("download.default_directory", TMP_DIR)
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.default_driver = :selenium
Capybara.default_max_wait_time = 5

class Chase
  verbose, $VERBOSE = $VERBOSE, nil
  include Capybara::DSL
  $VERBOSE = verbose

  def logon(username, password)
    visit "https://chase.com"

    begin
      find("#logonbox")
    rescue Capybara::ElementNotFound
      click_on "Sign in"
    end

    within_frame(find("#logonbox")) do
      fill_in "Username", with: username
      fill_in "Password", with: password

      # https://github.com/searls/fine-ants/blob/e565afe1fd1deda98e861f2b662cc5b649e5e2ae/lib/fine_ants/adapters/chase.rb#L17-L19
      sleep 0.1

      click_on "Sign in"
    end

    raise "Couldn't log in" unless find "#logonDetailsContainer"
  end

  # https://github.com/searls/fine-ants
  def download(account, date_range)
    from_date = date_range.begin.strftime("%m/%d/%Y")
    to_date = date_range.end.strftime("%m/%d/%Y")

    find(:xpath, "//div[contains(@class, 'account-tile')]//h4/span[text()='CREDIT CARD']")
      .click

    find("h1#accountName", text: "CREDIT CARD")
    find("#creditCardTransTable") {|table| table.find_all("tr").size > 2 }

    click_link "downloadActivityIcon"

    click_button "Spreadsheet (Excel, CSV)"
    click_link "Quicken Web Connect (QFX)"

    click_button "Current display, including filters"
    click_link "Choose a date range"

    fill_in "accountActivityFromDate", with: from_date
    fill_in "accountActivityToDate", with: to_date

    find("body").click # defocus input field

    click_on "Download"

    qfx = nil
    until qfx = Dir.glob("#{TMP_DIR}/*.qfx", File::FNM_CASEFOLD).first
    end

    click_on "Go back to accounts"

    qfx
  end
end
