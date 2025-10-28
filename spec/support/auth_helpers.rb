require 'securerandom'
require 'bcrypt'

module AuthHelpers
  # Create a lightweight Account for tests
  def create_account(attrs = {})
    defaults = { email: "spec+#{SecureRandom.hex(6)}@example.org" }
    Account.create!(defaults.merge(attrs))
  end

  # For request specs: stub rodauth to behave as if the account is signed in
  def sign_in_request(account = nil)
    # Lightweight stub for tests that don't need full rodauth login flow.
    account ||= create_account
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :require_account).and_return(true)
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :account).and_return(account)
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :logged_in?).and_return(true)
    account
  end

  # For request specs: perform an actual Rodauth login by creating a verified account with a password
  # and POSTing to the login path so the session/cookie is set correctly for route constraints.
  def sign_in_request_via_rodauth(account = nil, password: 'password')
    account ||= create_account
    account.password_hash = BCrypt::Password.create(password).to_s
    account.status = :verified
    account.save!

    # Post to the rodauth login endpoint to establish session and cookies
    # Use the canonical login path "/login" (rodauh mounts this path)
    post '/login', params: { login: account.email, password: password }
    account
  end

  # For controller specs: set the session account id
  def sign_in_controller(account = nil)
    account ||= create_account
    session[:account_id] = account.id
    # also stub rodauth methods so controller's authenticate won't redirect
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :require_account).and_return(true)
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :account).and_return(account)
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :logged_in?).and_return(true)
    account
  end

  # Simple bypass that fakes an authenticated rodauth environment
  def bypass_rodauth
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :require_account).and_return(true)
    allow_any_instance_of(ApplicationController).to receive_message_chain(:rodauth, :logged_in?).and_return(true)
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :controller
end
