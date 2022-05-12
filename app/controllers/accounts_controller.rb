# Helper controller for rodauth acounts
# Only supports Index
class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end
end
