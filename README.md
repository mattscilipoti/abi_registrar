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
    - Associates with one or more Properties
    - Can be Deed Holders, Renters, or Dependents
    - Can mark as verified
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
  - Manage Beach Parties?
    - Reservations 
    - Sync to Invoices?
    - Vehicle Passes
  - Manage Beach Passes
    - Once lot fees are paid, mail Beach Passes to Deed Holders
    - Once non-DeedHolder residents are verified, mail them Beach Passes
  - Import Lots
  - Import Properties
  - Import Residents
  - Sync Lot Fees with QuickBooks
  - Manage Donations
    - In QuickBooks?
  - Manage Watercraft Slots
  - Manage Boat Ramp Stickers
    - Reports for Beach Checkers (Pass Number, Make, Model)
  - Manage Vehicle Stickers
    - Reports for Beach Checkers (Pass Number, Make, Model)