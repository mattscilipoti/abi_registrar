# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a CHANGELOG](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

In place of release version numbers, we organize via deploys to Production (by Date/Time).

## Upcoming: Import from ACA Data

- Import: convert source from "_Relationship Tables" to "2022_ACA_Membership" files
- Style
  - Index views: indicate resident_status & x of y models
    - Using new residencies/_property & _resident icon list views

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
