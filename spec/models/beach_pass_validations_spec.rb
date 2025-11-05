require 'rails_helper'

RSpec.describe BeachPass, type: :model do
  describe 'AmenityPassValidations' do
    it 'requires season_year on create' do
      bp = FactoryBot.build(:beach_pass, season_year: nil)
      expect(bp).not_to be_valid
      expect(bp.errors[:season_year]).to include("can't be blank")
    end

    it 'requires season_year to be within allowed range' do
      bp = FactoryBot.build(:beach_pass, season_year: 2022)
      expect(bp).not_to be_valid
      expect(bp.errors[:season_year]).to include('must be greater than or equal to 2023')

      bp2 = FactoryBot.build(:beach_pass, season_year: 2100)
      expect(bp2).not_to be_valid
      expect(bp2.errors[:season_year]).to include('must be less than 2100')
    end

    it 'accepts a valid season_year and unique sticker_number' do
      bp = FactoryBot.build(:beach_pass, season_year: Time.zone.now.year)
      expect(bp).to be_valid
    end

    it 'requires sticker_number presence' do
      bp = FactoryBot.build(:beach_pass, sticker_number: nil, season_year: Time.zone.now.year)
      expect(bp).not_to be_valid
      expect(bp.errors[:sticker_number]).to include("can't be blank")
    end

    it 'enforces uniqueness of sticker_number' do
      sn = "UNQ-#{Time.zone.now.to_i}"
      existing = FactoryBot.create(:beach_pass, sticker_number: sn, season_year: Time.zone.now.year)
      new_bp = FactoryBot.build(:beach_pass, sticker_number: sn, season_year: Time.zone.now.year)
      expect(new_bp).not_to be_valid
      expect(new_bp.errors[:sticker_number]).to include('has already been taken')
    end
  end
end
