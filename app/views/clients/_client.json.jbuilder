json.extract! client, :id, :name, :code, :contacts, :address, :partner, :tin, :created_at, :updated_at
json.url client_url(client, format: :json)
