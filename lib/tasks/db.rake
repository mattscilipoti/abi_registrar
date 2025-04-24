require_relative '../task_helpers/confirmation_helper'

namespace :db do
  include ConfirmationHelper

  # Simplified helper to print a basic association tree.
  def print_association_tree(record, depth: 0, max_depth: 2, prefix: '')
    return if depth > max_depth

    associations = record.class.reflect_on_all_associations
    associations.each_with_index do |association, idx|
      # Only process associations with dependent behavior.
      next unless [:destroy, :delete_all, :nullify].include?(association.options[:dependent])
      branch = (idx == associations.size - 1) ? '└── ' : '├── '
      associated = record.send(association.name)
      if associated.blank?
        puts "#{prefix}#{branch}#{association.name}: (none)"
      elsif associated.respond_to?(:each) && !associated.is_a?(String)
        puts "#{prefix}#{branch}#{association.name}:"
        associated.each_with_index do |child, cidx|
          child_branch = (cidx == associated.size - 1) ? '└── ' : '├── '
          puts "#{prefix}    #{child_branch}#{child.class.name}##{child.id}"
          print_association_tree(child, depth: depth + 1, max_depth: max_depth, prefix: prefix + "    ")
        end
      else
        puts "#{prefix}#{branch}#{association.name}: #{associated.class.name}##{associated.id}"
        print_association_tree(associated, depth: depth + 1, max_depth: max_depth, prefix: prefix + "    ")
      end
    end
  end

  desc 'Delete TEST data from the current database'
  task :delete_test_data => :environment do
    db_config = Rails.application.config.database_configuration[Rails.env]
    puts "Removing TEST data from the #{db_config['database']} database..."
    #TODO: delete all ItemTransactions first.
    test_residents = Resident.where(middle_name: 'TEST')
    puts "Deleting #{test_residents.count} test Residents"
    test_residents.each do |resident|
      resident_desc = "Resident##{resident.id} #{resident.full_name}"
      puts resident_desc
      print_association_tree(resident)
      if confirm_action("Delete #{resident_desc}?")
        resident.destroy!
        puts "Deleted #{resident_desc}"
      else
        puts "Skipped #{resident_desc}"
      end
    end

    test_lots = Lot.where('lot_number LIKE ?', '%(T)')
    puts "Deleting #{test_lots.count} test Lots"
    test_lots.each do |lot|
      lot_desc = "Lot##{lot.id} #{lot.lot_number}"
      puts lot_desc
      print_association_tree(lot)
      if confirm_action("Delete #{lot_desc}?")
        lot.destroy!
        puts "Deleted #{lot_desc}"
      else
        puts "Skipped #{lot_desc}"
      end
    end

    test_properties = Property.where('street_name LIKE ?', '%(TEST)')
    puts "Deleting #{test_properties.count} test Properties"
    test_properties.each do |property|
      property_desc = "Property##{property.id} #{property}"
      puts property_desc
      print_association_tree(property)
      if confirm_action("Delete #{property_desc}?")
        property.destroy!
        puts "Deleted #{property_desc}"
      else
        puts "Skipped #{property_desc}"
      end
    end
  end

  desc 'Delete item transaction data'
  task :delete_item_transactions => :environment do
    item_transactions_to_delete = ItemTransaction.all
    if confirm_action("Delete all item transactions (#{item_transactions_to_delete.count})?")
      item_transactions_to_delete.delete_all
      puts "Deleted all item transactions."
    else
      puts "Operation cancelled."
    end
  end
end
