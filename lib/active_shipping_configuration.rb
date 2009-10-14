class ActiveShippingConfiguration < Configuration

  preference :ups_login, :string, :default => "aunt_judy"
  preference :ups_password, :string, :default => "secret"
  preference :ups_key, :string, :default => "developer_key"
  
  preference :usps_login, :string, :default => "aunt_judy"

  preference :origin_country, :string, :default => "US"
  preference :origin_state, :string, :default => "PA"
  preference :origin_city, :string, :default => "University Park"
  preference :origin_zip, :string, :default => "16802"
  
  preference :units, :string, :default => "imperial"
  preference :unit_multiplier, :integer, :default => 16 # 16 oz./lb - assumes variant weights are in lbs
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
