require "test_helper"
require "minitest/spec"

class AllFactoriesTest < ActiveSupport::TestCase

  # convention: "base" factories return valid models.
  #   without these tests, factories with invalid associations are difficult to identify and debug
  #  Note: performs build, not create.
  describe 'all factories,' do
    factories_to_skip = {} # hash of name and reason

    FactoryBot.factories.each do |factory|
      it "Factory :#{factory.name} should be valid" do
        reason_to_skip = factories_to_skip[factory.name.to_sym]
        if reason_to_skip
          pending "PENDING: skipping Factory(:#{factory_name}), due to '#{reason_to_skip}'"
        else
          resource = factory.run(:build, {})
          # Note: attempted to use be_valid, but errors.full_messages was empty
          assert resource.valid?, message { resource.errors.full_messages.to_s }
        end
      end
    end
  end
end
