# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a CHANGELOG](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

In place of release version numbers, we organize via deploys to Production (by Date/Time).

## Upcoming: Add User Fee Paid On to Property

- Add Property.user_fee_paid_on to DB
- Add Property.mandatory_fees_paid?
- Add to Property & Resident index
- Add filters for mandatory fees
- AmenityPass checks confirm_resident_paid_mandatory_fees
- YearEnd resets user fee
- Summary includes BeachPass and user fee
- models_table supports model#default_sort

## Upcoming: Move Lot Fees To Property

- Add lot_fees_paid_on to Property
- Copy Lot Fees Paid from Lot to Property
- Update Year End to remove lot_fees_paid_on from Property

## 2023-11-15 Fix BoatRampPass#show

- Handle nil description

## 2023-10-30 Yearly Reset

- New menu/pages for Year End, resets Amenities Processed and Lot Fees

## 2023-05-22 AmenityPasses#index for public

- Allow anon access to amenity_passes#index
- Extract filters from searchbar_tag
- Change root to pages#home

## 2023-05-07 Upgrade ruby

- Ruby 3.1.3 to 3.1.4
- Add instructions to add administrators

## 2023-03-27 Amenity Pass Summaries

- 66 Create AmenityPassDecorator (each Pass has a decorator too)
  - Each Pass Decorator provides an icon
- 61 Add Passes to Summary page
- 61 Add Amenities Processed to Summary page

## 2023-03-17 Fix issue creating Dinghy/Watercraft Passes

- 68 Issue creating Dinghy
- Identified and fixed similar issue with Watercraft Passes

## 2023-03-14 Amentities Processed, Create New from Show page

- #35 Can manage AmentiesProcessed. Can toggle from index (checked assignes today's date)
- #57 Added link to Create New Amenity Pass on each Amnenity Show page.
- #55 Widen email field for Resident
- #37 Prettify Date inputs via html5

## 2023-02-15 Amenity Passes accept letters

- Amenity Passes:
  - Residents are sorted by last_name, first_name
  - (#53) Amentiy Sticker Numbers accept letters and numbers
    -  Sticker numbers must be unique

## 2023-02-03: Improve Lot/Property selection

- Sort Lots by lot_number
- Sort properties by street_name, street_number

## 2023/02/01: [#42](https://github.com/mattscilipoti/abi_registrar/issues/42) Easier Lot fee payment

- Checkbox in lot list on properties#show
- Added toggleable_lot_fee_paid? to LotDecorator

## 2023/01/31: [#38](https://github.com/mattscilipoti/abi_registrar/issues/38) Add Property to Resident, not Resident to Property

- Removes the ability to add a Resident to a Property (when looking at a Property), instead you add Properties to a Resident. We didn't see a way for you to search through existing Residents. Forcing this through a Resident, encourages us to search first, but we can add new one when we need to.

## 2023/01/29: [#34](https://github.com/mattscilipoti/abi_registrar/issues/34), Mark Properties For Sale

- Can mark properties for sale, in edit or index
  - Adds scope: for_sale
  - Property supports toggleable_for_sale? (via decorator)
- Add new JS: stimulus-rails-autosave
  - Upgrades stimulus to v3.2.1

## 2023/01/27: Amenities

- #21 Add spacing for Edit, List, Destroy links/buttons on Show pages
- #24 Convert Vehicle to AmenityPass (STI) as VehicleParkingPass
  - Rename vehicles table to amenities
  - Rename Vehicle to VehicleParkingPass < AmenityPass
    - Update routes, views, controllers, etc.
- #24 Can manage BoatRampAccessPasses, DinghyDockStoragePasses, WatercraftStoragePasses
- #28 Add phone to residents tooltip on properties#index
- #30 FIX Add new Resident
- #33 Clarify Mailing Address for new resident

## 2023/01/12: Add Resident on properties#show

- property#show
  - Can add a Resident to a Property
  - Can assign resident_type
- Fix first column show of models_table
- Residency:
  - verified? is based on resident_status (not verified_on)
- seed: add chairman, support
- db: config for heroku's DATABASE_URL
- Login: increase width of email field
- Create Footer: link to Github Issues
- Helpers
  - Add external_link_to

## 2022/10/11: Revised Import, Add gem: nilify_blanks

- Dependencies
  - add gem nilify_blanks to ensure empty input fields are persisted as nil
- Import
  - Import revised property and resident info
- residents#index: fix dependent scope

## 2022/10/02: Add ResidentTypes: border, significant_other, trustee

- Group search configuration in class method (configure_pgsearch)
- Residency
  - Add ResidentTypes: Border, Spouse, Trustee (Deed Holder)
    - Including db seeds
  - Remove ResidentTypes dependency on en.yml
- Dependencies
  - add psql (for dbconsole)

## 2022/09/22: Meeting 2022/09/11

- Property
  - Rename abi_member to membership_eligible
  - Move section, tax_id from Lot to Property
  - Derive tax_id components (they were stored)
- Resident
  - Add .search_by_name_sounds_like
  - Add scope without_primary_residence
- Import from new data file
  - revamp ImportLots, ImportProperties, ImportResidents
  - add gems: wannabe_bool, ruby_postal
  - add dependency: libpostal
    - heroku create --buildpack https://github.com/homelight/heroku-buildback-libpostal.git
  - ImportResident: assign_alt_email_as_comment, assign_alt_phone_as_comment, assign_mailing_address, assign_notes_to_property
    - strip names
  - ImportProperty: assign_notes_to_property

## 2022/09/08: Toggle attributes from table

- Resident:
  - add scopes not_deed_holder, renter
  - multiple places to verify resident
- Add jQuery
- Residency: new scope "by_property", sorts by property street, number
- config.host to abi-registrar.herokuapp.com

## 2022/08/22: Import Shares, Clean up import

- Imports
  - Extract ImporterLots, ImporterProperties
  - Identify Lot by TaxID, not LotNumber
  - Add import:shares_recent, ImporterSharesRecent
    - find shares by activity, quantity, residency, transacted_at
  - Add share import data files
- UI
  - Select contents of any input onClick
  - All index views default to none #performance
  - Added lots#index: Abi?, SunriseBeach?
  - Table
    - Boolean cols: limited width, centered in header and rows
    - Sticky headers!
- Lot
  - Add #abi_member?: Identifies lots asociated with ABI
    - Where subdivision is Sunrise Beach + exceptions
  - Add #abi_member_exceptions: lists tax_ids that are not in SB subdivision
  - Add #subdivision_is_sunrise_beach?
  - Fix #tax_identfier: pads all parts
- Property
  -add abi_member? (& scopes), assigned during import
- Resident
  - Add scope: deed_holder
  - No longer encrypting first_name
  - Can search_by_name with sounds-like (dmetaphone) and stems (tsearch)
- DB
  - Add dsupport for full-text searches, sounds-like (dmetaphone), stems (trigram), and fuzzy serch
  - Add gem "schema_plus_functions" to support functions in schema.rb

## 2022/05/31: Resident Mailing Address

- Resident:
  - Add mailing_address
  - Filter without_resident_status
  - Filter with/without mailing_address
- DB: add hstore extension

## 2022/05/29: Owner/Co-owner

- Residency
  - Convert Deed Holder to Owner/Co-owner
  - scope deed_holder is either owner/co-owner
  - Add column Residency#primary_residence:boolean
- Resident
  - Add #primary_residence and #mailing address
  - #phone removes non-numeric chars
  - #phone_i18n uses number_to_phone
- VS Code: use EditorConfig

## 2022/05/24: Import from ACA Data

- Import: convert source from "_Relationship Tables" to "2022_ACA_Membership" files
  - Rename ImporterMembers to ImporterResidents
  - ImporterResident: imports Lot#section
  - Add/Import Resident#phone
  - Rename task: import:abi_membership -> import:residents
- Property: add mailing_address (Crownsville)
- Resident: remove age_of_minor
- ItemTransaction:
  - Fix: can edit activity
  - Validate not in future
- Style
  - Index views: indicate resident_status & x of y models
    - Using new residencies/_property & _resident icon list views
  - Property#show: lists Lot_fee_paid? (as well as date)
  - Lot#paid_on formatted time_ago_in_words
  - Use icons for DeedHolder, Renter, Dependent
    - uses residencies_controller and views
- Seed
  - Rename JimR to "Peter PartialPayment"
  - Add dependent (Jill, 123 Main St.)
  - Add (random) comments
  - Phone numbers use 555 area code
- Config: Unpermitted parameters raises errors

## 2022-05-20: Filter by Scopes

- Resident
  - Add #verified?
  - Index: displays verified?
  - New scopes (verified/not_verified
- Convert to searchbar_tag, includes filter by scopes
  - filter_models handles scopes
  - Each models has .scopes
- Seed
  - seed: add data to exercise filters: renter w/o email, w/o first name

## 2022/05/17: Performance improvements, via filtering records

- Filter by "Problematic", "Not Paid"
  - Defaults to "Problematic"
  - Each Model has its own definition of "problematic" (e.g. No lot_number)
    - Add scopes to all models
  - Extract filter_models to ApplicationController
- DB:
  - Comment#content is required
  - Add Vehicle#state_code (searchable)
    - Vehicle.states for forms
- Style:
  - Use "⁇" for unknown values
  - Use .row for aligning row of items (flex)
  - Indexes: h1/table wrapped in fieldset
  - Search: add busy indicator to link clink and submit click
- Dep:
  - bundle cache --all-platforms
    - Fixes issues on Heroku (missing gems)

## 2022/05/16: Import Members and Shares

- New task: "import:abi_members"
  - Imports Lots, Properties, Resident1 & 2, via ImporterMembers
  - Add/Import Middle Name to Resident
- New task: "import:shares"
  - Imports Shares, via ImporterShares
  - Add :import to ItemTransaction#activity
  - WARN: Newly imported Residents are not Deed Holders. We bypassed this verification and selected the "first" Resident.
  - WARN: transacted_at DateTime will update for ALL Imported Share Transactions on EACH Import (I think this is appropriate, if we are using the same spreadsheet).
- Style:
  - Lot & Property#index lists residents and section
  - Increase search-form text size
- Deps:
  - Add amazing_print (formatting and colors - "abc".red)
  - Add active_admin_doctor
    - Added indices
    - Fixed Not Null/Presence validators

## 2022/05/13: Deploy to Heroku

- rodauth: enable enum_auth
- Configure for Heroku: database, email (MailGun)
- Seed
  - Allow seed in Production
  - Add webmaster
  - Use credentials
- Deps
  - Remove enum_help (had errors on Heroku). Workaround: use string in Enum hash.
  - Add forgotten vendor/cache

## 2022/05/11: Authentication

- ~~Manage Users~~ (removed in favor of rodauth)
- Authentication
  - Add rodauth-rails
  - All routes require authentication
  - Enable email auth
  - List account administrators
- Seed: use gem database_cleaner
- Style
  - Tooltips default to BELOW item

## 2022/05/10: Searching, Summary, TimeZone, Property Icons

- New Home Page: Summary
- Properties: Lists lot numbers
- Can search Lots, Properties, Residents, and Transactions
- Can manage Vehicles/Stickers
- Can add Comments to Resident, Property
- Styling
  - Use Draper Decorators for view specific model helpers
  - Tables: use ✓/❌ for boolean fields
  - Property house icons, with fancy tooltips
  - Fixed/simplified table sorting defaults
  - DateTimes shown in time_ago_in_words, tooltip is actual time
  - New Helpers: datetime_tag, number_with_percentage, search_form_tag
  - Pretty tooltips via data-tooltip
- Seeds
  - Jane Owner has 2 properties
    - Demo: One is 975 Main ("sister" to 975 Waterview)
  - All items created between 1 year ago and 1 week ago
- Configuration
  - TimeZone to Eastern
  - FontAwesome from 6.0.0 (beta) to 6.1.1
  - Add/Configure rspec
