namespace :import do
  desc "Imports Lots, Properties, and Residents (from ACA Membership source_"
  task :residents, [:source_file, :import_range] => [:environment] do |_t, args|
    # default_source_file = Rails.root.join('db', 'import' ,'_Relationship Tables.xlsx - ABI Membership.csv')
    default_source_file = Rails.root.join('db', 'import' ,'2022_ACA_Membership.csv')
    args.with_defaults(source_file: default_source_file)
    
    importer = ImporterResidents.new(args[:source_file])
    importer.import(range: args[:import_range])
  end

  desc "Imports 'ABI Shares' Sheet from '_Relationship Tables' file"
  task :shares, [:source_file, :import_range] => [:environment] do |_t, args|
    default_source_file = Rails.root.join('db', 'import', '_Relationship Tables.xlsx - ABI Shares.csv')
    args.with_defaults(source_file: default_source_file)
    
    importer = ImporterShares.new(args[:source_file])
    importer.import(range: args[:import_range])
  end
end
