# Add product packages relation
Spree::Product.class_eval do
  has_many :product_packages, :dependent => :destroy

  attr_accessible :product_packages_attributes
  accepts_nested_attributes_for :product_packages, :reject_if => lambda { |pp| pp[:weight].blank? or Integer(pp[:weight]) < 1 }
end
