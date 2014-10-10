require "core_ext/json"

class ResourceMap::Site
  json_schema({
    id: {type: Int32},
    name: {type: String},
    location: {type: Location, nilable: true},
    icon: {type: String, nilable: true},
  })

  property! collection_id

  def initialize(@id, @name, lat : Number, lon : Number, @collection_id = nil)
    @location = Location.new(lat, lon)
  end

  def initialize(@id, lat : Number, lon : Number)
    @name = "Some name"
    @location = Location.new(lat, lon)
  end
end
