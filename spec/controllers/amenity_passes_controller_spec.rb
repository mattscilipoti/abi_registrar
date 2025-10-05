require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe AmenityPassesController, type: :controller do
  before do
    # Bypass Rodauth authentication for controller specs
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
  end

  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }
  let!(:amenity_pass) { FactoryBot.create(:beach_pass, resident: resident) }
  let!(:other_reason) { FactoryBot.create(:void_reason, :other) }

  describe 'PATCH #confirm_void' do
    context "when selecting 'Other' without providing a note" do
      it 'does not void the pass and responds with 422 Unprocessable Entity' do
        patch :confirm_void, params: {
          id: amenity_pass.id,
          beach_pass: {
            void_reason_id: other_reason.id,
            voided_reason: ''
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(amenity_pass.reload.voided_at).to be_nil
      end
    end

    context "when selecting 'Other' and providing a note" do
      it 'voids the pass and persists the reason and note' do
        patch :confirm_void, params: {
          id: amenity_pass.id,
          beach_pass: {
            void_reason_id: other_reason.id,
            voided_reason: 'User provided custom reason'
          }
        }

        expect(response).to have_http_status(:found) # redirect after success

        amenity_pass.reload
        expect(amenity_pass.voided_at).to be_present
        expect(amenity_pass.void_reason_id).to eq(other_reason.id)
        expect(amenity_pass.voided_reason).to eq('User provided custom reason')
      end
    end
  end
end
