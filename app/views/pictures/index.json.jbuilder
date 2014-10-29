json.array!(@pictures) do |picture|
  json.extract! picture, :id, :user_id, :title, :source_type, :source_id
  json.url picture_url(picture, format: :json)
end
