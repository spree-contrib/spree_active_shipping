Admin::ShippingMethodsController.class_eval do
  private

  # overriding to return an array of Calculator objects instead of a Set
  def load_data
    @available_zones = Zone.find :all, :order => :name
    @calculators = ShippingMethod.calculators.sort_by(&:description)
  end
end
