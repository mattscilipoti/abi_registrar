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
