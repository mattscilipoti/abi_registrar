json.extract! user, :id, :email, :last_name, :first_name, :admin, :created_at, :updated_at
json.url user_url(user, format: :json)
