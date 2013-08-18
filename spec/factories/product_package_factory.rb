FactoryGirl.define do
  factory :product_package, class: Spree::ProductPackage do
    length { SecureRandom.random_number(19) + 1 }
    width { SecureRandom.random_number(19) + 1 }
    height { SecureRandom.random_number(19) + 1 }
    weight { SecureRandom.random_number(19) + 1 }
    product
  end 
end