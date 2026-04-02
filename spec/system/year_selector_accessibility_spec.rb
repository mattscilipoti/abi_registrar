require 'rails_helper'

RSpec.describe 'Year selector accessibility', type: :system do
  before do
    driven_by :rack_test
  end

  it 'includes ARIA attributes and exposes focusable links' do
    # Create a verified account with a password so we can log in via the UI
    account = Account.create!(email: "spec+#{SecureRandom.hex(6)}@example.org", status: :verified)
    account.password_hash = BCrypt::Password.create('password').to_s
    account.save!

    # Visit the login page and sign in
    visit '/login'
    within('form#login-form') do
      fill_in 'login', with: account.email
      find('input[type=submit], button[type=submit]').click
    end
    # Fill in password on the next form
    within('form#login-form') do
      fill_in 'password', with: 'password'
      find('input[type=submit], button[type=submit]').click
    end

    resident = FactoryBot.create(:resident)
    FactoryBot.create(:beach_pass, resident: resident, season_year: 2025)
    FactoryBot.create(:beach_pass, resident: resident, season_year: 2024)

    visit amenity_passes_path

    # Year selector exists on the page
    expect(page).to have_selector('.year-list')

    # Year links exist and are anchors with href and visible text
    year_links = page.all('.year-list a')
    expect(year_links).not_to be_empty
    year_links.each do |a|
      expect(a[:href]).to be_present
      expect(a.text.strip).not_to be_empty
      # Each link should include an aria-label that mentions the pass count for accessibility
      expect(a['aria-label']).to be_present
      expect(a['aria-label']).to match(/pass/)
    end

    # Clicking a year should mark the active link with aria-current and include the count
    # The view now renders counts inside the link text (e.g. "2024 (1)").
    # Find and click the link whose text begins with the year label so the test is robust
    find('.year-list a', text: /^2024/).click
    active_links = page.all('.year-list a[aria-current="true"]')
    # Expect the active link's aria-label to include the year and a numeric count
    expect(active_links.map { |a| a['aria-label'] }).to satisfy { |labels|
      labels.any? { |l| l.match?(/2024.*\d+/) }
    }
  end
end
