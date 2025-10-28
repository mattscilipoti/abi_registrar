Year filter (season_year) — Design notes
======================================

Purpose
-------
This document explains the year-filter feature centered on a `season_year` column for pass models, the `PassYearable` concern and the controller `RequireYearParam` behavior. It's a short, executable design note intended to help maintainers understand where to wire the feature, the expected behavior, and safe rollout steps.

Contract (inputs, outputs, success criteria)
-------------------------------------------
- Input: a collection of "pass" records (AmenityPass and similar) and an HTTP param `year`.
- Output: the collection filtered according to `year` and decorated for views.
- Behavior:
  - `year == 'all'` => return all records (including those with `season_year: nil`).
  - `year` blank or nil => treat as the current calendar year.
  - numeric year (String or Integer) => return only records where `season_year == year`.
  - Controller/route should redirect requests missing `params[:year]` to the same path with the current year inserted (so links are bookmarkable).

Key pieces (files and roles)
----------------------------
- app/models/concerns/pass_yearable.rb
  - Provides scope `by_year(year)` implementing the contract above.

- app/models/amenity_pass.rb (and other pass models)
  - Include `PassYearable`.
  - Provide `available_years` (distinct non-nil season_year values ordered desc) to build selectors.

- app/controllers/concerns/require_year_param.rb
  - `before_action` that redirects to the same path with `year=Time.zone.now.year` when `params[:year]` is missing.

- app/controllers/*_passes_controller.rb
  - Include `RequireYearParam` and apply `.by_year(params[:year])` in `index` actions. Keep index endpoints idempotent and safe for pagination.

- app/views/layouts/_year_selector.html.slim
  - Shared partial that renders the year choices (accepts `model:` and `compact:` locals) and links to the index path with the selected `year`.

- spec/support/year_filter_shared_examples.rb and spec/README.md
  - Shared specs and test guidance (use `sign_in_request_via_rodauth` for request specs when routes are constrained by Rodauth.)

Database and migration guidance
-------------------------------
- Column: `season_year` (integer) must exist on pass tables used by the filter.
- Index: add an index on `season_year` for efficient filtering:

  add_index :amenity_passes, :season_year

- Backfill strategy (production-safe):
  1. Add the nullable `season_year` column in one migration (no backfill). Deploy.
  2. Run a separate, idempotent backfill script (rake task) that updates records in batches (e.g., 1k-10k rows per transaction) with appropriate logging.
  3. After backfill and verification, add a non-null constraint if desired and adjust code paths.

Testing guidance
----------------
- Keep detailed testing and auth-helper usage in `spec/README.md` (this repo's test-focused doc).
- Unit/controller specs should use `sign_in_controller` for fast feedback. Request specs that cross routing constraints should use `sign_in_request_via_rodauth` to establish a real session cookie.

Performance and correctness notes
--------------------------------
- Ensure index presence on `season_year` to avoid full table scans when filtering large pass tables.
- When rendering lists, include associations (`.includes(:resident, :properties)`) where appropriate to avoid N+1 queries.

Rollout checklist
-----------------
1. Create migration to add `season_year` (nullable) and index.
2. Deploy migration to staging and production (column only).
3. Run backfill rake task in small batches; verify sample records.
4. Deploy code that uses `by_year` (this branch).
5. Run smoke tests (basic request specs) to validate index and selector render.
6. Optionally add a non-null constraint and re-run tests if you want to enforce `season_year` always present.

References
----------
- Test guidance: `spec/README.md`
- Shared examples: `spec/support/year_filter_shared_examples.rb`
- Year selector partial: `app/views/layouts/_year_selector.html.slim`
