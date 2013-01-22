# Add product packages relation
Spree::LineItem.class_eval do
  has_many :product_packages, :through => :product
end