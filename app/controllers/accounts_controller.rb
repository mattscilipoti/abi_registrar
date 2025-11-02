# Helper controller for rodauth acounts
# Only supports Index
class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end

  # POST /accounts/update_season_year
  def update_season_year
    year = params[:season_year]
    if year.present? && year.to_s.match?(/\A\d+\z/)
      AppSetting.set('current_season_year', year.to_s)
      redirect_to accounts_path, notice: "Current season year updated to #{year}"
    else
      redirect_to accounts_path, alert: 'Please provide a valid year.'
    end
  end
end
