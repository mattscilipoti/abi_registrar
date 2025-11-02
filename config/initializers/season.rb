# frozen_string_literal: true

# This initializer previously configured a CURRENT_SEASON_YEAR ENV override.
# That behavior has been removed; the application now uses the DB-backed
# AppSetting.current_season_year with a Time.zone.now.year fallback.

# Intentionally left blank to avoid relying on ENV-driven season configuration.
