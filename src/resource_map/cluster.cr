class ResourceMap::Cluster
  property! id, site, lat, lon
  property min_lat, max_lat, min_lon, max_lon
  getter count

  def initialize
    @lat_sum = 0.0
    @lon_sum = 0.0
    @alert = false
    @status = true
    @ord = 100
    @count = 0
    @min_lat = 90.0
    @max_lat = -90.0
    @min_lon = 180.0
    @max_lon = -180.0
    @highlighted = false
  end

  def add(site)
    @count += 1

    location = site.location.not_nil!
    lat, lon = location.lat, location.lon

    @colletion_id ||= site.collection_id?
    @min_lat = lat if lat < @min_lat
    @min_lon = lon if lon < @min_lon
    @max_lat = lat if lat > @max_lat
    @max_lon = lon if lon > @max_lon
    @status = false if site.collection_id? != @collection_id
    @icon = site.icon || ""
    @lat_sum += lat
    @lon_sum += lon
  end

  def close
    @lat = @lat_sum /= @count
    @lon = @lon_sum /= @count
    @icon = @status ? @icon : "default"
  end
end
