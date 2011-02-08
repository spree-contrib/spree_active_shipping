class Calculator::Usps::MediaMail < Calculator::Usps::Base
  def self.description
    "USPS Media Mail"
  end

  def self.service_name
    "USPS Media Mail&amp;lt;sup&amp;gt;&amp;amp;reg;&amp;lt;/sup&amp;gt;"
  end
end
