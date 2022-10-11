namespace :import do
  desc "Imports Lots (from Arden Properties source)"
  task :lots, [:source_file, :import_range] => [:environment] do |_t, args|
    # default_source_file = Rails.root.join('db', 'import' ,'_Relationship Tables.xlsx - ABI Membership.csv')
    # default_source_file = Rails.root.join('db', 'import' ,'2022_ACA_Membership.csv')
    # default_source_file = Rails.root.join('db', 'import' ,'Arden Property Owners & NSB Properties.xlsx - Property Attributes.csv')
    default_source_file = Rails.root.join('db', 'import' ,'Arden Property Attributes.xlsx - Property Attributes.csv')
    args.with_defaults(source_file: default_source_file)

    importer = ImporterLots.new(args[:source_file])
    importer.import(range: args[:import_range])
  end

  desc "Imports Properties (from Arden Properties source)"
  task :properties, [:source_file, :import_range] => [:environment] do |_t, args|
    # default_source_file = Rails.root.join('db', 'import' ,'_Relationship Tables.xlsx - ABI Membership.csv')
    # default_source_file = Rails.root.join('db', 'import' ,'2022_ACA_Membership.csv')
    # default_source_file = Rails.root.join('db', 'import' ,'Arden Property Owners & NSB Properties.xlsx - Property Attributes.csv')
    default_source_file = Rails.root.join('db', 'import' ,'Arden Property Attributes.xlsx - Property Attributes.csv')
    args.with_defaults(source_file: default_source_file)

    importer = ImporterProperties.new(args[:source_file])
    importer.import(range: args[:import_range])
  end

  desc "Imports Residents (from Arden Properties source)"
  task :residents, [:source_file, :import_range] => [:environment] do |_t, args|
    # default_source_file = Rails.root.join('db', 'import' ,'_Relationship Tables.xlsx - ABI Membership.csv')
    # default_source_file = Rails.root.join('db', 'import' ,'2022_ACA_Membership.csv')
    # default_source_file = Rails.root.join('db', 'import' ,'Arden Property Owners & NSB Properties.xlsx - Owner-Contact Info (8-24-22).csv')
    default_source_file = Rails.root.join('db', 'import' ,'Arden Property Attributes.xlsx - Owner-Contact Info.csv')
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

  desc "Imports recent ABI Share Purchases from 'SharesRegistrarSpreadsheet.xlsx' file"
  task :shares_recent, [:source_file, :import_range] => [:environment] do |_t, args|
    default_source_file = Rails.root.join('db', 'import', 'SharesRegistrarSpreadsheet.xlsx - 2021-2022.csv')
    args.with_defaults(source_file: default_source_file)

    importer = ImporterSharesRecent.new(args[:source_file])
    importer.import(range: args[:import_range])
  end
end
