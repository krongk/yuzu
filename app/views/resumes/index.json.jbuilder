json.array!(@resumes) do |resume|
  json.extract! resume, :id, :user_id, :cate_id, :name, :summary, :sex, :age, :education, :work_year, :content, :phone, :qq, :region_id, :city_id, :district_id, :pv_count, :fav_count, :is_processed
  json.url resume_url(resume, format: :json)
end
