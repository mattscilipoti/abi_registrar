# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a CHANGELOG](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

In place of release version numbers, we organize via deploys to Production (by Date/Time).

## 2022/05/06 Searching, Summary, TimeZone, Property Icons

- New Home Page: Summary
- Properties: Lists lot numbers
- Can search Lots, Properties, Residents, and Transactions
- Can manage Vehicles/Stickers
- Can add Comments to Resident, Property
- Styling
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
