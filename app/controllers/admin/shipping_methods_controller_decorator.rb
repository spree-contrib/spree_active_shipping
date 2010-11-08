Admin::ShippingMethodsController.class_eval do
  
  before_filter :load_data
  
  private

  # overriding to return an array of Calculator objects instead of a Set
  def load_data
    @available_zones = Zone.find :all, :order => :name
    @calculators = []
    ShippingMethod.calculators.each {|calc|
      @calculators << eval(calc.name).new  
    }
  end
end