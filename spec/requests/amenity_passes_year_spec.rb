require 'rails_helper'

RSpec.describe 'AmenityPasses year filtering', type: :request do
  describe 'GET /amenity_passes' do
    it 'redirects missing year to current year' do
      get amenity_passes_path
      expect(response).to redirect_to(/year=#{Time.zone.now.year}/)
    end

    it "accepts 'all' and returns passes including nil season_year" do
      with_year = FactoryBot.create(:beach_pass, season_year: 2023)
      without = FactoryBot.create(:beach_pass, season_year: nil)
      get amenity_passes_path, params: { year: 'all' }
      expect(response).to have_http_status(:ok)
      # views render sticker digits (numeric portion); match on digits
      with_digits = with_year.sticker_number.to_s.match(/\d+/)[0]
      without_digits = without.sticker_number.to_s.match(/\d+/)[0]
      expect(response.body).to include(with_digits)
      expect(response.body).to include(without_digits)
    end

    it 'applies numeric year filter' do
      p2024 = FactoryBot.create(:beach_pass, season_year: 2024)
      p2025 = FactoryBot.create(:beach_pass, season_year: 2025)
      get amenity_passes_path, params: { year: '2024' }
      expect(response).to have_http_status(:ok)
      d2024 = p2024.sticker_number.to_s.match(/\d+/)[0]
      d2025 = p2025.sticker_number.to_s.match(/\d+/)[0]
      expect(response.body).to include(d2024)
      expect(response.body).not_to include(d2025)
    end
  end
end
