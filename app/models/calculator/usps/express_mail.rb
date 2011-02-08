class Calculator::Usps::ExpressMail < Calculator::Usps::Base
  def self.description
    "USPS Express Mail"
  end

  def self.service_name
    "USPS Express Mail&amp;lt;sup&amp;gt;&amp;amp;reg;&amp;lt;/sup&amp;gt;"
  end
end
