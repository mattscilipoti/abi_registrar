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
end
