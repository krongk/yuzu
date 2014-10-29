json.array!(@jobs) do |job|
  json.extract! job, :id, :user_id, :cate_id, :title, :mobile_phone, :email, :salary, :content, :region_id, :city_id, :district_id, :detail_address, :is_processed
  json.url job_url(job, format: :json)
end
