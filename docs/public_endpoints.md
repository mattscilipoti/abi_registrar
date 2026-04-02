# Public endpoints / Anonymous access

Authentication in this app is enforced globally in `app/controllers/application_controller.rb` via:

- `before_action :authenticate` which calls `rodauth.require_account`.

Any controller action that calls `skip_before_action :authenticate` (or lives in a controller that does) will be accessible to anonymous users. The routes defined outside the `constraints Rodauth::Rails.authenticated do ... end` block in `config/routes.rb` can also be reached by unauthenticated visitors.

Currently the intentionally-public endpoints are:

- `GET /home` -> `PagesController#home` (declares `skip_before_action :authenticate, only: [:home]`).
- `GET /amenity_passes` -> `AmenityPassesController#index` (declares `skip_before_action :authenticate, only: [:index]`). This is used for the public view of amenity passes.
- Rodauth controller endpoints (login/registration/etc.) are served by `RodauthController` which calls `skip_before_action :authenticate` so authentication flows are reachable.

Notes and how to change this behavior

- To make an action private: remove the corresponding `skip_before_action :authenticate` or limit it to fewer actions.
- To make an action public: add `skip_before_action :authenticate, only: [:action_name]` to the controller.
- Many application routes are wrapped in `constraints Rodauth::Rails.authenticated` in `config/routes.rb`; moving a route into or out of that block will respectively restrict or expose it at the routing level.

Quick grep commands to find public/skip hooks:

```bash
grep -nR "skip_before_action" app/controllers || true
grep -nR -E "before_action .*authenticate" app/controllers || true
```

Documenting these endpoints here helps reviewers understand which parts of the app are intentionally public (for example, the amenity passes index is a public-facing listing).
