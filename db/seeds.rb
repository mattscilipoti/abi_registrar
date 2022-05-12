# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

unless ENV['FORCE_SEED'] == Rails.env || %w[development test].include?(Rails.env)
  raise "Safety net: If you really want to seed the '#{Rails.env}' database, use FORCE_SEED=#{Rails.env}"
end

puts 'Cleaning db, via truncation...'
require 'database_cleaner-active_record'
do_not_truncate = %w[]
DatabaseCleaner.clean_with :truncation, except: do_not_truncate

puts "Seeding database..."
Faker::Config.random = nil # seeds the PRNG using default entropy sources

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

lot24 = FactoryBot.create(:lot, lot_number: 24, size: 1, paid_on: 1.day.ago)
lot42 = FactoryBot.create(:lot, lot_number: 42, size: 0.5)
property_123Main = FactoryBot.create(:property, lots: [lot24], street_number: '123', street_name: 'Main St')
property_975Main = FactoryBot.create(:property, lots: [lot42], street_number: '975', street_name: 'Main St')

jqo = FactoryBot.create(:resident, last_name: 'Owner', first_name: 'Jane', email_address: 'janeowner@example.com')

FactoryBot.create(:residency, property: property_123Main, resident: jqo, resident_status: :deed_holder, verified_on: 1.day.ago)
FactoryBot.create(:residency, property: property_975Main, resident: jqo, resident_status: :deed_holder, verified_on: 1.day.ago)

jqr = FactoryBot.create(:resident, last_name: 'Renter', first_name: 'John Q.', email_address: 'johnqrenter@example.com', properties: [property_975Main]).tap do |resident|
  resident.residencies.first.update(
    resident_status: :renter,
    verified_on: 1.day.ago
  )
end

FactoryBot.create(:share_transaction, :purchase, quantity: 10, residency: mms.residencies.first)
FactoryBot.create(:share_transaction, :purchase, quantity: 20, residency: jr.residencies.first)
FactoryBot.create(:share_transaction, :transfer, quantity: 10, from_residency: jr.residencies.first, residency: cbs.residencies.first)

Resident.lot_fees_paid.each {|r| FactoryBot.create(:vehicle, resident: r) }

Account.create!(
  email: 'registrar@ardenbeachesinc.com',
  password_hash: BCrypt::Password.create("change_me").to_s,
  status:     2, # verified
)

Account.create!(
  email: 'webmaster@ardenbeachesinc.com',
  password_hash: BCrypt::Password.create("change_me").to_s,
  status:     2, # verified
)
