class ResourceMap::Clusterer
  CellSize = 115.0

  def initialize(@zoom)
    @width, @height = self.class.cell_size_for zoom
    @clusters = Hash({Int32, Int32}, Cluster).new { |h, k| h[k] = Cluster.new }
    @sites = [] of Site
    @clustering_enabled = @zoom < 20
  end

  def add(site)
    location = site.location
    return unless location

    unless @clustering_enabled
      @sites << site
      return
    end

    x, y = cell_for location

    cluster = @clusters[{x, y}]
    cluster.id = "#{@zoom}:#{x}:#{y}"
    cluster.add site
    if cluster.count == 1
      cluster.site = site
    else
      cluster.site = nil
    end
  end

  record Clusters, sites, clusters

  def clusters
    if @clustering_enabled
      clusters_with_clustering_enabled
    else
      clusters_with_clustering_disbaled
    end
  end

  private def clusters_with_clustering_enabled
    clusters_to_return = [] of Cluster
    sites_to_return = [] of Site

    @clusters.each_value do |cluster|
      count = cluster.count
      if count == 1
        site = cluster.site
        sites_to_return << site
      else
        cluster.close
        clusters_to_return << cluster
      end
    end

    sites_to_return = nil if sites_to_return.empty?
    clusters_to_return = nil if clusters_to_return.empty?

    Clusters.new(sites_to_return, clusters_to_return)
  end

  private def clusters_with_clustering_disbaled
    Clusters.new([] of Site, nil)
  end

  protected def self.cell_size_for(zoom)
    zoom = zoom.to_i
    zoom = 2 ** (zoom)
    {CellSize / zoom, CellSize / zoom}
  end

  private def cell_for(location)
    x = ((90 + location.lon) / @width).floor
    y = ((180 + location.lat) / @height).floor
    {x, y}
  end
end
