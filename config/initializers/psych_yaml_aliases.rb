# Enable YAML aliases (anchors/merges) only for specific, trusted YAML files.
#
# Context: Psych 4 (bundled with Ruby 3.1+) made YAML loading "safe" by default
# which disables aliases unless explicitly allowed. Some Rails config files
# like config/database.yml commonly use anchors/aliases (e.g., `<<: *default`).
#
# This initializer whitelists specific paths and forces aliases: true for them
# without relaxing safety globally. Do NOT add user-controlled files here.

require "yaml"
require "erb"

# Add absolute paths of YAML files in your app that intentionally use aliases.
ALIAS_ENABLED_YAML_PATHS = [
	Rails.root.join("config/database.yml").to_s,
	# Rails.root.join("config/your_other.yml").to_s,
].map { |p| File.expand_path(p) }.freeze

module YAML
	class << self
		# Wrap YAML.safe_load to force aliases: true when filename is whitelisted.
		unless method_defined?(:safe_load_without_alias_whitelist)
			alias_method :safe_load_without_alias_whitelist, :safe_load
		end

		def safe_load(yaml, **kwargs)
			path = kwargs[:filename]
			if path && ALIAS_ENABLED_YAML_PATHS.include?(File.expand_path(path.to_s))
				kwargs = kwargs.merge(aliases: true)
			end
			safe_load_without_alias_whitelist(yaml, **kwargs)
		end

		# Wrap YAML.load_file to ERB-evaluate and enable aliases when whitelisted.
		# This covers callers that rely on load_file without explicitly allowing aliases.
		unless method_defined?(:load_file_without_alias_whitelist)
			alias_method :load_file_without_alias_whitelist, :load_file
		end

		def load_file(filename, ...)
			path = File.expand_path(filename.to_s)
			if ALIAS_ENABLED_YAML_PATHS.include?(path)
				content = ERB.new(::File.read(path)).result
				# Delegate to safe_load with filename so our wrapper above applies.
				return YAML.safe_load(content, filename: path)
			end
			load_file_without_alias_whitelist(filename, ...)
		end

		# Some environments expose YAML.safe_load_file; support it if present.
		if respond_to?(:safe_load_file)
			unless method_defined?(:safe_load_file_without_alias_whitelist)
				alias_method :safe_load_file_without_alias_whitelist, :safe_load_file
			end

			def safe_load_file(filename, **kwargs)
				path = File.expand_path(filename.to_s)
				if ALIAS_ENABLED_YAML_PATHS.include?(path)
					content = ERB.new(::File.read(path)).result
					return YAML.safe_load(content, **kwargs.merge(filename: path))
				end
				safe_load_file_without_alias_whitelist(filename, **kwargs)
			end
		end
	end
end

