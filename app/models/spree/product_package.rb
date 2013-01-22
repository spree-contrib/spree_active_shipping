module Spree
  class ProductPackage < ActiveRecord::Base
    belongs_to :product

    validates :length, :width, :height, :weight, :numericality => { :only_integer => true, :message => I18n.t('validation.must_be_int'), :greater_than => 0 }

    attr_accessible :length, :width, :height, :weight
  end
end
