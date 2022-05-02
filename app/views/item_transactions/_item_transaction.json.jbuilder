json.extract! item_transaction, :id, :type, :cost_per, :quantity, :cost_total, :resident_id, :created_at, :updated_at
json.url item_transaction_url(item_transaction, format: :json)
