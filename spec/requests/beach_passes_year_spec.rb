require 'rails_helper'

RSpec.describe 'BeachPasses year filtering', type: :request do
  let(:index_path) { :beach_passes_path }
  let(:factory_name) { :beach_pass }

  include_examples 'year filter request'
end
