require "../spec_helper"

module ResourceMap
  describe Clusterer do
    it "leaves single site alone" do
      clusterer = Clusterer.new 1
      clusterer.add(site = Site.new(1, "Site 1", 30, 40, collection_id: 12))

      clusters = clusterer.clusters
      clusters.sites.should eq([site])
      clusters.clusters.should be_nil
    end

    it "puts two sites in a cluster" do
      clusterer = Clusterer.new 1
      clusterer.add Site.new(1, 20, 30)
      clusterer.add Site.new(2, 21, 31)

      clusters = clusterer.clusters
      clusters.sites.should be_nil
      cs = clusters.clusters.not_nil!
      cs.length.should eq(1)
      c = cs[0]
      c.id.should eq("1:2:3")
      c.lat.should eq(20.5)
      c.lon.should eq(30.5)
      c.count.should eq(2)
      c.min_lat.should eq(20)
      c.max_lat.should eq(21)
      c.min_lon.should eq(30)
      c.max_lon.should eq(31)
    end

    it "puts four sites in two different clusters" do
      clusterer = Clusterer.new 1
      clusterer.add Site.new(1, 20, 30)
      clusterer.add Site.new(2, 21, 31)
      clusterer.add Site.new(3, 65, 120)
      clusterer.add Site.new(4, 66, 121)

      clusters = clusterer.clusters
      clusters.sites.should be_nil
      cs = clusters.clusters.not_nil!
      cs.length.should eq(2)
    end
  end
end
