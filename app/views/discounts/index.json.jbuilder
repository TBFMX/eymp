json.array!(@discounts) do |discount|
  json.extract! discount, :id, :titulo, :precio, :vencimiento, :equipment_id
  json.url discount_url(discount, format: :json)
end
