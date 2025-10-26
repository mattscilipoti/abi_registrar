require 'rails_helper'

RSpec.describe AmenityPassesController, type: :controller do
  describe 'GET #index' do
    context 'when year param is missing' do
      it 'redirects to the same path with current year param' do
        get :index
        expect(response).to redirect_to(/year=#{Time.zone.now.year}/)
      end
    end

    context "when year param is present as 'all'" do
      it 'does not redirect and assigns amenity passes' do
        get :index, params: { year: 'all' }
        expect(response).to have_http_status(:ok)
        ivar = controller.instance_variable_get(:@amenity_passes)
        expect(ivar).not_to be_nil
      end
    end

    context 'when year param is present as numeric' do
      it 'does not redirect and applies the by_year scope' do
        p = FactoryBot.create(:beach_pass, season_year: Time.zone.now.year)
        get :index, params: { year: Time.zone.now.year }
        expect(response).to have_http_status(:ok)
        ivar = controller.instance_variable_get(:@amenity_passes)
        # ivar is a Draper decorator collection; extract models for assertion
        models = ivar.respond_to?(:map) ? ivar.map(&:model) : []
        expect(models).to include(p)
      end
    end
  end
end
