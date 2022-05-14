namespace :import do
  desc "Imports 'ABI Membership' Sheet from '_Relationship Tables' file"
  task :abi_membership, [:source_file, :import_range] => [:environment] do |_t, args|
    default_source_file = Rails.root.join('tmp','_Relationship Tables.xlsx - ABI Membership.csv')
    args.with_defaults(source_file: default_source_file)
    
    importer = ImporterMembers.new(args[:source_file])
    importer.import(range: args[:import_range])
  end

  desc "Imports 'ABI Shares' Sheet from '_Relationship Tables' file"
  task :shares, [:source_file, :import_range] => [:environment] do |_t, args|
    default_source_file = Rails.root.join('tmp', '_Relationship Tables.xlsx - ABI Shares.csv')
    args.with_defaults(source_file: default_source_file)
    
    importer = ImporterShares.new(args[:source_file])
    importer.import(range: args[:import_range])
  end
end
