class Property < ApplicationRecord
  include Filterable

  acts_as_geolocated

  MAX_RADIUS_METERS = 5.0 * 1000.0

  scope :near, -> (lat, lng) {
    within_radius(MAX_RADIUS_METERS, lat, lng).order_by_distance(lat, lng)
  }

  # Here two scopes to filter by market_type or offer_type
  scope :filter_by_offer_type, -> (offer_type) {
    where(offer_type: offer_type)
  }

  scope :filter_by_marketing_type, -> (marketing_type) {
    where(offer_type: marketing_type)
  }

  # filter by property_type
  scope :filter_by_property_type, -> (property_type) {
    where(property_type: property_type)
  }

  # filter by location
  scope :filter_by_location, -> (location) {
    near(location[:lat], location[:lng])
  }

  def distance_to_other_property other_property
    select("earth_distance(ll_to_earth(#{self.lat}, #{self.lng}), ll_to_earth(#{other_property.lat}, #{other_property.lng}))").where(id: self.id).first.distance
  end

  # this instance method to calculate the distance in meters
  def distance_to_location location
    Property.select("earth_distance(ll_to_earth(#{self.lat}, #{self.lng}), ll_to_earth(#{location[:lat]}, #{location[:lng]})) as distance").where(id: self.id).first.distance
  end
end
