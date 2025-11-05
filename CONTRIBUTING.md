CONTRIBUTING
============

Thanks for contributing! This file is a high-level guide for contributors: how to get the app running locally, a recommended quick feedback workflow, and where to find more detailed developer and testing documentation.

Devcontainer
------------

This repository includes a VS Code Dev Container configuration in `.devcontainer/`. If you use VS Code, open the folder in the devcontainer (Remote - Containers: "Open Folder in Container") or use GitHub Codespaces to get a reproducible development environment with the correct Ruby and system dependencies. Run the same setup commands below from inside the container (for example, `bundle install` and `bin/rails server`). If you prefer to work locally without the container, follow the "Quick start (local)" steps below.

Quick start (local)
--------------------

1. Install dependencies

   bundle install

2. Prepare the database

   bin/rails db:create db:migrate db:seed

3. Run the app

   bin/rails server

Testing
-------

Run the full test suite:

```bash
bundle exec rspec
```



Contributor workflow (fast feedback)
----------------------------------

When working locally, run fast checks first to get quick feedback, then run the full suite before opening a PR.

1. Create a feature branch:

```bash
git checkout -b issue#_succint_description
```

2. Run fast checks (linters + unit/controller specs):

```bash
# optional lint
bundle exec rubocop || true

# run model and controller specs only
bundle exec rspec spec/models spec/controllers
```

3. Run focused request specs related to your change:

```bash
bundle exec rspec spec/requests/path_to_spec.rb
```

4. If your request spec needs a logged-in session and the route is protected by Rodauth, use the real-login helper:

```ruby
# in your request spec before block
sign_in_request_via_rodauth(create(:account))
```

5. Run the full suite before opening a PR:

```bash
bundle exec rspec
```

Where to find detailed guidance
------------------------------
- Test-specific guidance (auth helpers, shared examples, and performance tips) lives in `spec/README.md`.
- Design and architecture discussion (year-filter behavior, migration/backfill strategy) lives in `DESIGN.md`.

Database schema (ActualDbSchema)
-------------------------------

This project uses the `actual_db_schema` gem (config: `config/initializers/actual_db_schema.rb`) to manage migrations as you switch from branch to branch. The UI is enabled in development and migrated phantom files live in `tmp/migrated`.

Contributing code
-----------------

- Follow existing code style. Run RuboCop locally if enabled.
- Add tests for behavior you change. Keep the test suite green locally before opening PRs.
- Update `CHANGELOG.md` and `README.md` when appropriate.

Support
-------

If you have questions, open an issue or contact the repository owner (see `README.md` for contacts).

Thanks for contributing — small, well-tested changes keep the codebase healthy.
