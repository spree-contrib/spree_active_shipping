class Calculator::Usps::PriorityMail < Calculator::Usps::Base
  def self.description
    "USPS Priority Mail"
  end

  def self.service_name
    "USPS Priority Mail&amp;lt;sup&amp;gt;&amp;amp;reg;&amp;lt;/sup&amp;gt;"
  end
end
