require 'factory_bot'

class FactoriesTest < ActiveSupport::TestCase
  def test_factories_are_valid
    FactoryBot.lint
  end
end
