module Ups
  class NextDayAir < ActiveShippingCalculator  
    def initialize
      super(Ups::NextDayAir)
    end
  end
end