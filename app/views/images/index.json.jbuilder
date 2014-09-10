json.array!(@images) do |image|
  json.extract! image, :id, :gallery_id, :image_url, :title
  json.url image_url(image, format: :json)
end
