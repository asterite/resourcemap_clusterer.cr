require "net/http"
require "resource_map"

include ResourceMap

# client = HTTP::Client.new "localhost", port: 9200
# response = client.get "collection_1/site/_search", body: %({"filter":{"and":[{"exists":{"field":"location"}},{"geo_bounding_box":{"location":{"top_left":{"lat":43.125,"lon":43.125},"bottom_right":{"lat":-21.5625,"lon":136.5625}}}}]},"size":100000})

json = File.read("collection_870.json")

time = Time.now
clusterer = Clusterer.new 19
sites_finder = SiteFinder.new clusterer
sites_finder.parse json
clusters = clusterer.clusters
# puts clusters.clusters.try &.map &.id
puts Time.now - time
