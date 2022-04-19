
module EnumHelp

  module I18n
    fail "Is this workaround still required?" if Gem.loaded_specs['enum_help'].version > Gem::Version.create('0.0.18')
    if ActiveRecord::VERSION::MAJOR == 7
      # overwrite the enum method
      def enum(name = nil, values = nil, **options)
        super(name, values, **options)
        # WORKAROUND: add enum_name_i18n helper
        Helper.define_attr_i18n_method(self, name)
        Helper.define_collection_i18n_method(self, name)
        
        definitions = options.slice!(:_prefix, :_suffix, :_scopes, :_default)
        definitions.each do |name, _|
          Helper.define_attr_i18n_method(self, name)
          Helper.define_collection_i18n_method(self, name)
        end
      end
    end
  end
end