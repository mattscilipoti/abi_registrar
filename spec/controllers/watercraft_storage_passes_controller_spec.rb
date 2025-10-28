require 'rails_helper'

RSpec.describe WatercraftStoragePassesController, type: :controller do
  let(:factory_name) { :watercraft_storage_pass }
  let(:assigned_ivar) { :@watercraft_storage_passes }

  include_examples 'year filter controller'
end
