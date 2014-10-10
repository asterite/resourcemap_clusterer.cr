require "core_ext/json"

struct ResourceMap::Location
  json_schema({
    lat: {type: Float64},
    lon: {type: Float64},
  })

  def inspect(io : IO)
    io << "(" << lat << ", " << lon << ")"
  end
end
