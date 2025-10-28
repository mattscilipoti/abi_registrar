# Shared examples for year filtering behavior
RSpec.shared_examples 'year filter request' do
  describe 'GET index year filtering' do
    before do
      # sign in for request specs using full rodauth login so route constraints pass
      @account = sign_in_request_via_rodauth
    end
    it 'redirects missing year to current year' do
      get send(index_path)
      expect(response).to redirect_to(/year=#{Time.zone.now.year}/)
    end

    it "accepts 'all' and returns passes including nil season_year" do
      with_year = FactoryBot.create(factory_name, season_year: 2023)
      without = FactoryBot.create(factory_name, season_year: nil)
      get send(index_path), params: { year: 'all' }
      expect(response).to have_http_status(:ok)
      with_digits = with_year.sticker_number.to_s.match(/\d+/)[0]
      without_digits = without.sticker_number.to_s.match(/\d+/)[0]
      expect(response.body).to include(with_digits)
      expect(response.body).to include(without_digits)
    end

    it 'applies numeric year filter' do
      p2024 = FactoryBot.create(factory_name, season_year: 2024)
      p2025 = FactoryBot.create(factory_name, season_year: 2025)
      get send(index_path), params: { year: '2024' }
      expect(response).to have_http_status(:ok)
      d2024 = p2024.sticker_number.to_s.match(/\d+/)[0]
      d2025 = p2025.sticker_number.to_s.match(/\d+/)[0]
      expect(response.body).to include(d2024)
      expect(response.body).not_to include(d2025)
    end
  end
end

RSpec.shared_examples 'year filter controller' do
  describe 'GET #index' do
    before do
      # sign in for controller specs by setting session via helper
      sign_in_controller
    end
    context 'when year param is missing' do
      it 'redirects to the same path with current year param' do
        get :index
        expect(response).to redirect_to(/year=#{Time.zone.now.year}/)
      end
    end

    context "when year param is present as 'all'" do
      it 'does not redirect and assigns passes' do
        get :index, params: { year: 'all' }
        expect(response).to have_http_status(:ok)
        ivar = controller.instance_variable_get(assigned_ivar)
        expect(ivar).not_to be_nil
      end
    end

    context 'when year param is present as numeric' do
      it 'does not redirect and applies the by_year scope' do
        p = FactoryBot.create(factory_name, season_year: Time.zone.now.year)
        get :index, params: { year: Time.zone.now.year }
        expect(response).to have_http_status(:ok)
        ivar = controller.instance_variable_get(assigned_ivar)
        models = ivar.respond_to?(:map) ? ivar.map(&:model) : []
        expect(models).to include(p)
      end
    end
  end
end
