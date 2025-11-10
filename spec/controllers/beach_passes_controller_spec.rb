require 'rails_helper'

RSpec.describe BeachPassesController, type: :controller do
  let(:factory_name) { :beach_pass }
  let(:assigned_ivar) { :@beach_passes }

  include_examples 'year filter controller'
end
