json.array!(@equipment) do |equipment|
  json.extract! equipment, :id, :name, :year, :color, :brand_id, :package_id, :description, :publication_type, :category_id
  json.url equipment_url(equipment, format: :json)
end
