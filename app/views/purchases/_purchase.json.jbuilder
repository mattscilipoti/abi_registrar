json.extract! purchase, :id, :type, :cost_per, :quantity, :cost_total, :resident_id, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
