json.array!(@users) do |user|
  json.extract! user, :id, :username, :name, :lastname, :email, :login_date, :password_date, :rol_id
  json.url user_url(user, format: :json)
end
