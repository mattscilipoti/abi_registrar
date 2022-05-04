# ABI Registrar

Tools to support the registrar positoin for Arden Beaches Inc. (ABI)
- Lots
  - Lot Fees
- Properties
- Residents

Not only do we need to gather and manage the approprite information, we need to make it available to people, where they need it. This includes printing reports for off-line use.
- Possible Report Options:
  - export to Google Sheet & printing from there.

## Features

### Done

  - Manage Lots
    - Record Lot fee payments (not connected to Quickbooks)
  - Manage Properties
    - Have one or more Lots
    - Owned by one or more Residents
  - Manage Residents
    - Associated with one or more Properties
    - Can be Deed Holders, Renters, or Dependents
    - Can mark as verified
    - Search by Last Name, Property Address, or Lot info
  - Manage Shares
    - Record Purchased Shares
      - Only Deed Holders
      - Each transation: Date purchased, count
      - Total count owned
      - Assign shares to Property
    - Transfer Shares
    - Can Edit/Delete via Item Tranaactions
  - Audit Transactions
    - ItemTransactions#show lists previous versions


### TODO
  - Audit Transactions
    - Undo lastest change
    - Revert to previous version
    - List deleted transactions
  - Find Transactions
    - Filter by Type, Activity
  - Manage Property
    - Link to SDAT
  - Manage Property Transfer
    - Inform ACA
    - Transfer Residency
    - Transfer Shares
    - Support Onboarding
      - What steps occur for new Residents?
    - List past Owners
  - Manage Beach Parties?
    - A: probably not. Registrar manages this outside of this app. Uses this app to verify Resident
    - Reservations
    - Sync to Invoices?
    - Vehicle Passes
  - Manage Beach Passes
    - Requested via Jotform
    - Verify
      - Verified Resident
      - Lot fees to be paid
    - Email Beach Passes to Deed Holders, with QR Code
  - Import Lots
  - Import Properties
  - Import Residents
  - Sync Lot Fees with QuickBooks
  - Manage Donations
    - In QuickBooks?
  - Manage Watercraft Slots
    - Reports for Beach Checkers (Pass Number, Description of Watercraft[optional])
  - Manage Boat Ramp Stickers
    - Reports for Beach Checkers (Pass Number, Trailer Tag Number/Boat Registration Number)
    - Verify
      - Requires Vehicle
  - Manage Vehicle Stickers
    - Reports for Beach Checkers (Pass Number, Vehicle Tag Number, Make, Model)
  - Manage Beach Checkers?
    - Reports of work performed
    - Recording beach activity
    - Record incidents
