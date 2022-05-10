# ABI Registrar

Tools to support the registrar positoin for Arden Beaches Inc. (ABI)
- Lots
  - Lot Fees
- Properties
- Residents
- Amenities
- Shares

Not only do we need to gather and manage the approprite information, we need to make it available to people, where they need it. This includes printing reports for off-line use.
- Possible Report Options:
  - export to Google Sheet & printing from there.

## Features

### Done

  - Manage Lots
    - Record Lot fee payments (not connected to Quickbooks)
    - Search by Lot, Property, or Resident info
  - Manage Properties
    - Have one or more Lots
    - Owned by one or more Residents
    - Add date-stamped Comments
    - Search by Property, Lot, or Resident info
  - Manage Residents
    - Associated with one or more Properties
    - Can be Deed Holders, Renters, or Dependents
    - Mark as verified
    - Search by Last Name, Property Address, or Lot info
    - Add date-stamped Comments
  - Manage Shares
    - Record Purchased Shares
      - Only Deed Holders
      - Each transation: Date purchased, count
      - Total count owned
      - Assign shares to Property
    - Transfer Shares
    - Can Edit/Delete via Item Tranaactions
  - Manage Vehicle Stickers
    - Assign Sticker and Vehicle to Resident
    - Search via Sticker Number, Tag Number, or Resident info
  - Manage Transactions
    - Search via by Type, Activity, Resident, Property
  - Audit Transactions
    - ItemTransactions#show lists previous versions
  - Add Summary page (as Home page)
  - Configuration
    - Display DateTime in Eastern Time Zone


### TODO
  - Security
    - Authentication
  - Audit Transactions
    - Undo lastest change
    - Revert to previous version
    - List deleted transactions
      - Restore  deleted transaction
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
    - (possible) Email Beach Passes to Deed Holders, with QR Code
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
  - Optimizations
    - Why some Versions.reify.nil?
    - Show all Date/Times in Eastern
  - Lots
    - Subdivide a lot
  - Resident
    - Mailing Address
      - Can select associated Property
    - Do we need age?
      - Only for vetting! Just store minor.
      - Possibly store: What year do they turn 21?
  - Email Blasts
     - Requirements
       - To all residents
       - To all holders of a specific pass type
       - To all share holders
     - Needs: email provider (e.g. SendGrid, MailChimp?) to manage email blacklists, etc.
       - Need ability to unsubscribe
       - Sending bulk emails can be problemtic for our domain: ardenbeachesinc.com
         - Your IP address(es) or domain(s) may be blacklisted by internet service providers for many reasons: if they see a sudden spike in email volume, complaints from receivers, or sending to bad emails.
       - https://www.mailgun.com/blog/deliverability/email-blasts-dos-donts-mass-email-sending/
       - https://pearllemonleads.com/bulk-emails-top-pitfalls-to-avoid/
