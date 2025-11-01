require 'rails_helper'

RSpec.describe 'Year selector', type: :system do
  before do
    driven_by :rack_test
  end

  it 'renders the year selector and allows selecting a year' do
    # Create a verified account with a password so we can log in via the UI
    account = Account.create!(email: "spec+#{SecureRandom.hex(6)}@example.org", status: :verified)
    account.password_hash = BCrypt::Password.create('password').to_s
    account.save!

    # Create sample passes in two different years
    resident = FactoryBot.create(:resident)
    FactoryBot.create(:beach_pass, resident: resident, season_year: 2025, sticker_number: 'A-1')
    FactoryBot.create(:beach_pass, resident: resident, season_year: 2024, sticker_number: 'B-2')

    # Visit the login page and sign in
    visit '/login'
    # Rodauth in this app shows a single 'login' field (email) on the login form; submit that
    fill_in 'login', with: account.email
      # Submit the form without relying on the exact button text
    within('form') { find('input[type=submit], button[type=submit]').click }

    # Visit the amenity passes index (should render the year selector)
    visit amenity_passes_path

    expect(page).to have_selector('.year-selector')
    expect(page).to have_selector('.year-list')
    # The selector should mark 2024 as active
    # The page should show links for the two years we created (visible text includes the year)
    link_texts = page.all('.year-list a').map(&:text)
    expect(link_texts.any? { |t| t.start_with?('2025') }).to be true
    expect(link_texts.any? { |t| t.start_with?('2024') }).to be true

    # Click the 2024 link (match by prefix) and assert the page updates the year param
    find('.year-list a', text: /^2024/).click
    expect(URI.parse(current_url).query).to include('year=2024')

    # The selector should mark 2024 as active
    active_texts = page.all('.year-list .active').map(&:text)
    expect(active_texts.any? { |t| t.start_with?('2024') }).to be true
  end
end
