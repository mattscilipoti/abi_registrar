require 'rails_helper'

RSpec.describe AmenityPass, type: :model do
  describe 'season_year default' do
    it 'defaults to AppSetting.current_season_year for new records' do
      current = AppSetting.current_season_year
      pass = AmenityPass.new
      expect(pass.season_year).to eq(current)
    end

    it 'does not override an explicitly provided season_year' do
      not_current_year = AppSetting.current_season_year - 1
      pass = AmenityPass.new(season_year: not_current_year)
      expect(pass.season_year).to eq(not_current_year)
    end
  end
end

RSpec.describe AmenityPass, type: :model do
  describe 'validations' do
    it 'requires a resident' do
      # Provide a sticker_number so sticker validation does not obscure the resident error
      pass = AmenityPass.new(sticker_number: 'R-999')
      pass.valid?
      expect(pass.errors[:resident]).not_to be_empty
    end
  end
end
require 'rails_helper'

RSpec.describe AmenityPass, type: :model do
  describe '#sticker_digits' do
    it 'returns digits for a valid sticker' do
      p = AmenityPass.new(sticker_number: 'R-25134')
      expect(p.sticker_digits).to eq('25134')
    end

    it 'returns digits for a prefixed void text' do
      p = AmenityPass.new(sticker_number: 'VOID R-25134')
      expect(p.sticker_digits).to eq('25134')
    end

    it 'returns digits when sticker contains parentheses and extra text' do
      p = AmenityPass.new(sticker_number: 'R-24164 (VOID) - NOT RECEIVED')
      expect(p.sticker_digits).to eq('24164')
    end

    it 'returns nil when there are no digits' do
      p = AmenityPass.new(sticker_number: 'NO DIGITS HERE')
      expect(p.sticker_digits).to be_nil
    end

    it 'returns first numeric run when multiple runs exist' do
      p = AmenityPass.new(sticker_number: 'A12-B345')
      expect(p.sticker_digits).to eq('12')
    end
  end

  describe '.guess_season_year_from_sticker' do
    it 'parses two-digit year 26 as 2026 for numeric and prefixed stickers' do
      expect(AmenityPass.guess_season_year_from_sticker('260001')).to eq(2026)
      expect(AmenityPass.guess_season_year_from_sticker('R-260001')).to eq(2026)

      p = AmenityPass.new(sticker_number: 'R-260001')
      expect(p.guess_season_year_from_sticker).to eq(2026)
    end
  end

  describe '.by_year' do
    let(:current_year) { Time.zone.now.year }

    it 'filters by numeric year (string or integer)' do
      p2024 = FactoryBot.create(:beach_pass, season_year: 2024)
      p2025 = FactoryBot.create(:beach_pass, season_year: 2025)
      expect(AmenityPass.by_year('2024')).to include(p2024)
      expect(AmenityPass.by_year(2025)).to include(p2025)
      expect(AmenityPass.by_year('2024')).not_to include(p2025)
    end

    it "treats nil/blank as the current year" do
      now_pass = FactoryBot.create(:beach_pass, season_year: current_year)
      other = FactoryBot.create(:beach_pass, season_year: current_year - 1)
      expect(AmenityPass.by_year(nil)).to include(now_pass)
      expect(AmenityPass.by_year('')).to include(now_pass)
      expect(AmenityPass.by_year(nil)).not_to include(other)
    end

    it "'all' returns everything including nil season_year" do
      with_year = FactoryBot.create(:beach_pass, season_year: 2023)
      without = FactoryBot.build(:beach_pass, season_year: nil)
      without.save(validate: false)
      expect(AmenityPass.by_year('all')).to include(with_year, without)
    end
  end
end
