Purpose
-------
This file documents the testing conventions we use in this repository, with a short reference for the centralized test auth helpers found in `spec/support/auth_helpers.rb` and guidance on when to use request vs controller specs.

Why this exists
----------------
- Tests run in different scopes. Some routes are protected by a route-level Rodauth constraint (inside `constraints Rodauth::Rails.authenticated`), so request specs that need to pass that constraint must establish a real session (cookie). Stubbing controller methods is not enough when the route-level constraint blocks the request before it reaches the controller.

When to use which spec
-----------------------
- Request specs (recommended for full-stack behavior)
  - Use when you need to exercise routing, middleware, constraints (Rodauth), or full HTTP flow.
  - Example: verifying the year filter behavior for index pages that live inside authenticated route constraints.
  - Use the real-login helper `sign_in_request_via_rodauth` for routes protected by Rodauth.

- Controller specs (focused, faster)
  - Use when testing small, focused controller behavior that does not require routing/middleware verification.
  - Controller specs can use `sign_in_controller` or simple stubs to set `session` and stub rodauth helpers.

Auth helpers (quick reference)
-----------------------------
These helpers are defined in `spec/support/auth_helpers.rb`. Short usage examples below.

- sign_in_request_via_rodauth(account = nil, password: 'password')
  - Creates (or accepts) an `Account`, ensures it has a password hash, then POSTs to the app's `/login` endpoint to establish a real session cookie recognized by route-level constraints.
  - Use in request specs that must cross the Rodauth constraint.

  Example:

  before do
    account = create(:account)
    sign_in_request_via_rodauth(account)
  end

- sign_in_request(account = nil)
  - A lightweight helper for request specs that don't need the full-route Rodauth login. It may stub or set minimal session state depending on the helper implementation.

- sign_in_controller(account = nil)
  - For controller specs. Sets session and stubs rodauth controller helpers so you can exercise controller logic without the full HTTP stack.

- bypass_rodauth
  - Shortcut to disable Rodauth constraints in tests that require it. Use sparingly — prefer a real login for request specs that assert routing/middleware behavior.

Examples
--------
Request spec that requires a real login:

RSpec.describe "BeachPasses year filtering", type: :request do
  let(:account) { create(:account) }

  before do
    # Real login: establishes a cookie/session that will pass route-level constraints
    sign_in_request_via_rodauth(account)
  end

  it "applies the year filter" do
    get beach_passes_path(year: Date.current.year)
    expect(response).to have_http_status(:ok)
    # ...assert body or assigns as required
  end
end

Controller spec (focused):

RSpec.describe BeachPassesController, type: :controller do
  before do
    # Fast: stub the controller-level auth and session
    sign_in_controller(create(:account))
  end

  it "filters by year when provided" do
    get :index, params: { year: Date.current.year }
    expect(response).to have_http_status(:ok)
    # ...assert assigns or rendered template
  end
end

Running tests
-------------
- Run a single spec file:

  bundle exec rspec spec/requests/beach_passes_year_spec.rb

- Run the whole test suite:

  bundle exec rspec

Tips and notes
--------------
- Prefer the real-login helper (`sign_in_request_via_rodauth`) for request specs that need to pass route-level auth constraints — this approach avoids brittle stubbing and tests the full HTTP auth flow.
- Convert controller specs to request specs when you need to ensure middleware/route constraints or full-stack behavior; keep controller specs for focused controller-only logic.
- If a test is failing with a 302 redirect to `/login`, it's likely the route-level Rodauth constraint blocked the request; switch to `sign_in_request_via_rodauth` in that request spec.

Where to look for implementation
--------------------------------
- `spec/support/auth_helpers.rb` — implementations for `sign_in_request_via_rodauth`, `sign_in_request`, `sign_in_controller`, and `bypass_rodauth`.
- `spec/support/year_filter_shared_examples.rb` — examples that show how we exercise year filters across controllers and requests.

If you want me to expand this into a longer `spec/README.md` (with troubleshooting steps, debugging RSpec output, and CI examples), tell me which sections you'd like and I will add them.

Performance note — slow specs and tips to speed them up
-----------------------------------------------------
- Which specs are slow
  - Request specs that perform a real Rodauth login (via `sign_in_request_via_rodauth`) and render full views are the slowest tests in this suite. They exercise the full HTTP stack and create fixtures that exercise view rendering.

- Quick tips to speed up test runs
  - Run focused specs during development. Execute a single file or a spec line to limit work:

    bundle exec rspec spec/requests/amenity_passes_year_spec.rb

    bundle exec rspec spec/requests/amenity_passes_year_spec.rb:12

  - Prefer controller specs (fast) for tightly bounded controller logic that doesn't need middleware/routing verification. Use request specs only when you need full-stack verification (routing, middleware, Rodauth constraints).

  - Use lighter factories where possible. If a factory triggers heavy callbacks (creating many associated records), consider a leaner factory or traits for the heavy associations, and only create them where necessary.

  - Use DatabaseCleaner/transactional tests (configured by default in this project) to avoid expensive cleanup steps.

  - If a test needs a logged-in user but doesn't need the route-level Rodauth constraint, prefer `sign_in_controller` (controller specs) or `sign_in_request` (request stubs) instead of the full `sign_in_request_via_rodauth` flow.

- CI strategy
  - Run a fast pipeline that executes linters and the unit/controller specs first, and run the slower request/system specs in a separate job (nightly or a 'slow-tests' stage) if runtime is a concern.

If you'd like, I can:
- Add a short section to `CONTRIBUTING.md` describing the recommended local workflow for fast feedback (which commands to run during development).
- Add a CI job matrix that splits fast/slow tests.

