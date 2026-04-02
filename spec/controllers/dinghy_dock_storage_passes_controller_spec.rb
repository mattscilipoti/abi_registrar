require 'rails_helper'

RSpec.describe DinghyDockStoragePassesController, type: :controller do
  let(:factory_name) { :dinghy_dock_storage_pass }
  let(:assigned_ivar) { :@dinghy_dock_storage_passes }

  include_examples 'year filter controller'
end
