json.array!(@notifications) do |notification|
  json.extract! notification, :id, :message, :is_processed
  json.url notification_url(notification, format: :json)
end
