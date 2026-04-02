require 'rails_helper'

RSpec.describe UtilityCartPassesController, type: :controller do
  let(:factory_name) { :utility_cart_pass }
  let(:assigned_ivar) { :@utility_cart_passes }

  include_examples 'year filter controller'
end
