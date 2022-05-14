namespace :import do
  desc "Imports 'ABI Membership' Sheet from '_Relationship Tables' file"
  task :abi_membership, [:source_file, :import_range] => [:environment] do |_t, args|
    importer = ImporterMembers.new(args[:source_file])
    importer.import(range: args[:import_range])
  end
end
