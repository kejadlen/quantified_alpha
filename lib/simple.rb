#!/usr/bin/env ruby

require_relative "capybara_setup"
require "capybara/dsl"

class Simple
  verbose, $VERBOSE = $VERBOSE, nil
  include Capybara::DSL
  $VERBOSE = verbose

  # https://github.com/searls/fine-ants
  def login(username, password, &block)
    visit "https://www.simple.com"
    click_link "Log In"

    fill_in "login_username", with: username
    fill_in "login_password", with: password
    click_button "Sign In"
    begin
      find_field "Enter 4-digit code"
      answer = block.call
      fill_in "Enter 4-digit code", with: answer
      click_button "Verify"
    rescue Capybara::ElementNotFound
      raise LoginFailedError unless find("h2", text: "Safe-to-Spend")
    end
  end

  def download
    find_button("Export")
      .hover
      .find(:xpath, "../div")
      .find_button("Export as JSON")
      .click

    json = nil
    until json = Dir.glob("#{TMP_DIR}/*.json", File::FNM_CASEFOLD).first
    end

    json
  end
end
