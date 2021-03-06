json.array!(@products) do |product|
  json.extract! product, :id, :user_id, :cate_id, :title, :mobile_phone, :email, :content, :price, :region_id, :city_id, :district_id, :detail_address, :is_processed
  json.url product_url(product, format: :json)
end
