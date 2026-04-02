require 'rails_helper'
require 'factory_bot_rails'

# Define a concrete subclass for testing the abstract class AmenityPass
# This approach is preferred over using an existing subclass because it isolates the tests
# and ensures that changes to the existing subclasses do not affect the tests for the abstract class.
class TestAmenityPass < AmenityPass
  self.table_name = 'amenity_passes'
end

RSpec.describe TestAmenityPass, type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }
  subject(:amenity_pass) { FactoryBot.build(:test_amenity_pass, resident: resident) }

  describe 'associations' do
    it { should belong_to(:resident) }
    it { should have_many(:properties).through(:resident) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:sticker_number) }

    it 'validates that resident has paid mandatory fees' do
      allow(resident).to receive(:lot_fees_paid?).and_return(false)
      allow(resident).to receive(:user_fee_paid?).and_return(false)
      amenity_pass.valid?
      expect(amenity_pass.errors[:resident]).to include("must have paid lot fees")
      expect(amenity_pass.errors[:resident]).to include("must have paid user fee")
    end

    context 'sticker_number format' do
      it 'accepts letter-hyphen-digits e.g., A-123' do
        amenity_pass.sticker_number = 'A-12345'
        expect(amenity_pass).to be_valid
      end

      it 'rejects missing hyphen' do
        amenity_pass.sticker_number = 'A12345'
        expect(amenity_pass).to be_invalid
        expect(amenity_pass.errors[:sticker_number]).to include('must be letter-hyphen-digits like A-123')
      end

      it 'rejects multi-letter prefixes' do
        amenity_pass.sticker_number = 'AB-12345'
        expect(amenity_pass).to be_invalid
      end

      it 'rejects non-digit suffix' do
        amenity_pass.sticker_number = 'A-12B45'
        expect(amenity_pass).to be_invalid
      end

      it 'rejects lowercase prefix (a-12345)' do
        amenity_pass.sticker_number = 'a-12345'
        expect(amenity_pass).to be_invalid
      end
    end
  end

  describe 'scopes' do
    it '.not_voided returns non-voided amenity passes' do
      not_voided_pass = FactoryBot.create(:test_amenity_pass, voided_at: nil, resident: resident)
      FactoryBot.create(:test_amenity_pass, voided_at: Time.now, resident: resident)
      expect(TestAmenityPass.not_voided).to eq([not_voided_pass])
    end

    it '.without_tag_number returns amenity passes without tag number' do

      without_tag_number_pass = FactoryBot.create(:test_amenity_pass, tag_number: nil, resident: resident)
      FactoryBot.create(:test_amenity_pass, tag_number: '12345', resident: resident)
      expect(TestAmenityPass.without_tag_number).to eq([without_tag_number_pass])
    end
  end

  describe '#void' do
    it 'sets voided_at to current time' do
      amenity_pass.save
      amenity_pass.void
      expect(amenity_pass.voided_at).to be_within(1.second).of(Time.current)
    end
  end

  describe '#voided?' do
    it 'returns true if voided_at is set' do
      amenity_pass.voided_at = Time.current
      expect(amenity_pass.voided?).to be true
    end

    it 'returns false if voided_at is not set' do
      amenity_pass.voided_at = nil
      expect(amenity_pass.voided?).to be false
    end
  end
end

RSpec.describe AmenityPass, type: :model do
  describe '(validations)' do
    it 'requires a resident' do
      # Provide a sticker_number so sticker validation does not obscure the resident error
      pass = AmenityPass.new(sticker_number: 'R-999')
      pass.valid?
      expect(pass.errors[:resident]).not_to be_empty
    end
  end

  describe '(defaults)' do
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
