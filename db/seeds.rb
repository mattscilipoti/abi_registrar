# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ItemTransaction.destroy_all
Residency.destroy_all
Resident.destroy_all
Lot.destroy_all
Property.destroy_all

lot69 = FactoryBot.create(:lot, :paid, lot_number: 69, section: 1, size: 1, account_number: 11942300)
property_975 = FactoryBot.create(:property, lots: [lot69], street_number: '975', street_name: 'Waterview Dr')

mms = FactoryBot.create(:resident, last_name: 'Scilipoti', first_name: 'Matt', email_address: 'matt@scilipoti.name', properties: [property_975]).tap do |resident|
  resident.residencies.first.update(
    resident_status: :deed_holder,
    verified_on: 1.day.ago
  )
end

cbs = FactoryBot.create(:resident, last_name: 'Scilipoti', first_name: 'Cindy', email_address: 'cindy@scilipoti.name', properties: [property_975]).tap do |resident|
  resident.residencies.first.update(
    resident_status: :deed_holder,
    verified_on: 1.day.ago
  )
end

jhs = FactoryBot.create(:resident, :minor, last_name: 'Scilipoti', first_name: 'J', email_address: 'jh@scilipoti.name', age_of_minor: 17, properties: [property_975]).tap do |resident|
  resident.residencies.first.update(
    resident_status: :dependent,
    verified_on: 1.day.ago,
  )
end

lot70 = FactoryBot.create(:lot, :paid, lot_number: 70, section: 1, size: 1)
lot71 = FactoryBot.create(:lot, lot_number: 71, section: 1, size: 1)
property_977 = FactoryBot.create(:property, lots: [lot70, lot71], street_number: '977', street_name: 'Waterview Dr')

jr = FactoryBot.create(:resident, last_name: 'Rainwater', first_name: 'Jim', email_address: 'jim@example.com', properties: [property_977]).tap do |resident|
  resident.residencies.first.update(
    resident_status: :deed_holder,
    verified_on: 1.day.ago)
end

lot42 = FactoryBot.create(:lot, lot_number: 42, size: 0.5)
property_123 = FactoryBot.create(:property, lots: [lot42], street_number: '123', street_name: 'Main St')

jqo = FactoryBot.create(:resident, last_name: 'Owner', first_name: 'Jane', email_address: 'janeowner@example.com', properties: [property_123]).tap do |resident|
  resident.residencies.first.update(
    resident_status: :deed_holder,
    verified_on: 1.day.ago
  )
end

jqr = FactoryBot.create(:resident, last_name: 'Renter', first_name: 'John Q.', email_address: 'johnqrenter@example.com', properties: [property_123]).tap do |resident|
  resident.residencies.first.update(
    resident_status: :renter,
    verified_on: 1.day.ago
  )
end
