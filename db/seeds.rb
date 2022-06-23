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
require 'factory_bot_rails'
require 'faker'

DatabaseCleaner.allow_production = true
DatabaseCleaner.allow_remote_database_url = true
do_not_truncate = [Account.table_name]
DatabaseCleaner.clean_with :truncation, except: do_not_truncate

puts "Seeding database..."
Faker::Config.random = nil # seeds the PRNG using default entropy sources
Faker::Config.locale = 'en-US'

# Lots, Properties, and Residents
lot69 = FactoryBot.create(:lot, :paid, lot_number: '69 (T)', section: 1, size: 1, account_number: 11942300)
property_975 = FactoryBot.create(:property, lots: [lot69], street_number: '975', street_name: 'Waterview Dr (TEST)')

mms = FactoryBot.create(:resident, last_name: 'Scilipoti', first_name: 'Matt', email_address: 'matt@scilipoti.name')
FactoryBot.create(:residency, :coowner, :verified, property: property_975, resident: mms)

cbs = FactoryBot.create(:resident, last_name: 'Scilipoti', first_name: 'Cindy', email_address: 'cindy@scilipoti.name')
FactoryBot.create(:residency, :owner, :verified, property: property_975, resident: cbs)

jhs = FactoryBot.create(:resident, :minor, last_name: 'Scilipoti', first_name: 'J', email_address: 'jh@scilipoti.name')
FactoryBot.create(:residency, :dependent, :verified, property: property_975, resident: jhs)

lot70 = FactoryBot.create(:lot, :paid, lot_number: '70 (T)', section: 1, size: 1)
lot71 = FactoryBot.create(:lot, lot_number: '71 (T)', section: 1, size: 1)
property_977 = FactoryBot.create(:property, lots: [lot70, lot71], street_number: '977', street_name: 'Waterview Dr (TEST)')

pp = FactoryBot.create(:resident, last_name: 'PartialPayment', first_name: 'Peter', email_address: 'ppp@example.com')
FactoryBot.create(:residency, :owner, :verified, property: property_977, resident: pp)

lot11 = FactoryBot.create(:lot, :paid, lot_number: '11 (T)', size: 1)
lot12 = FactoryBot.create(:lot, lot_number: '12 (T)', size: 0.5)
property_123Main = FactoryBot.create(:property, lots: [lot11], street_number: '123', street_name: 'Main St (TEST)')
property_975Main = FactoryBot.create(:property, lots: [lot12], street_number: '975', street_name: 'Main St (TEST)')

jqo = FactoryBot.create(:resident, last_name: 'Owner', first_name: 'Jane', email_address: 'janeowner@example.com',
  mailing_address: { street_number: 987, street_name: 'Other St', city: 'SomewhereElse', state_code: 'MD', zip_code: '11111' }
)

FactoryBot.create(:residency, :owner, :verified, property: property_123Main, resident: jqo)
FactoryBot.create(:residency, :owner, :second_home, :verified, property: property_975Main, resident: jqo)

jillqd = FactoryBot.create(:resident, last_name: 'Depends', first_name: 'Jill')
FactoryBot.create(:residency, :dependent, :verified, property: property_123Main, resident: jillqd)

jqr = FactoryBot.create(:resident, last_name: 'Renter', first_name: 'John (no email)', email_address: nil)
FactoryBot.create(:residency, :renter, :verified, property: property_975Main, resident: jqr)

bqr = FactoryBot.create(:resident, last_name: 'Renter', first_name: 'Bob (unverified)', email_address: 'bobqrenter@example.com')
FactoryBot.create(:residency, :renter, :verified, property: property_975Main, resident: bqr)

jdoe = FactoryBot.create(:resident, last_name: 'Doe', first_name: nil, email_address: nil)
FactoryBot.create(:residency, :verified, property: property_975Main, resident: jdoe, resident_status: nil)


# Comments
Resident.all.each {|r| FactoryBot.create_list(:comment, rand(5), commentable: r) }

# Shares
FactoryBot.create(:share_transaction, :purchase, quantity: 10, residency: mms.residencies.deed_holder.sample)
FactoryBot.create(:share_transaction, :purchase, quantity: 20, residency: pp.residencies.deed_holder.sample)
FactoryBot.create(:share_transaction, :transfer, quantity: 10, from_residency: pp.residencies.deed_holder.sample, residency: cbs.residencies.deed_holder.sample)

# Vehicles
Resident.lot_fees_paid.each {|r| FactoryBot.create(:vehicle, resident: r) }

# Admins
test_admin_info = Rails.application.credentials.fetch(:test_admin)
if !Rails.env.production?
  Account.find_or_create_by(email: test_admin_info.fetch(:email)) do |account|
    account.password_hash = BCrypt::Password.create(test_admin_info.fetch(:password)).to_s
    account.status = 2 # verified
  end
end

Account.find_or_create_by(email: 'registrar@ardenbeachesinc.com') do |account|
  account.password_hash = BCrypt::Password.create(Rails.application.credentials.fetch(:temporary_password)).to_s
  account.status = 2 # verified
end

Account.find_or_create_by(email: 'webmaster@ardenbeachesinc.com') do |account|
  account.password_hash = BCrypt::Password.create(Rails.application.credentials.fetch(:temporary_password)).to_s
  account.status = 2 # verified
end

Account.find_or_create_by(email: 'matt@scilipoti.name') do |account|
  account.password_hash = BCrypt::Password.create(test_admin_info.fetch(:password)).to_s
  account.status = 2 # verified
end
