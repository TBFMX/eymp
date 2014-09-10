class Discount < ActiveRecord::Base
  belongs_to :equipment
  validates :titulo, uniqueness: true
  #validates_format_of :titulo, :with => /^([^\/]*)$/i
  validates :titulo, :precio, :vencimiento, :equipment_id, presence: true
  validates :precio, numericality: {greater_than_or_equal_to: 0.01}
end
