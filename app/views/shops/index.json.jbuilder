json.array!(@shops) do |shop|
  json.extract! shop, :id, :title, :user_id, :region_id, :city_id, :district_id, :detail_address, :content, :contact_name, :contact_phone, :website, :source, :source_url, :is_processed
  json.url shop_url(shop, format: :json)
end
