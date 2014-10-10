require "../spec_helper"

module ResourceMap
  class SiteFinder::SiteAcumulator
    getter sites

    def initialize
      @sites = [] of Site
    end

    def add(site)
      @sites << site
    end
  end

  describe SiteFinder do
    it "finds sites" do
      listener = SiteFinder::SiteAcumulator.new
      finder = SiteFinder.new(listener)

      json = File.read("#{__DIR__}/data/sites.json")
      finder.parse json

      sites = listener.sites
      sites.length.should eq(4)

      site = sites[0]
      site.id.should eq(1)
      site.collection_id.should eq(1)
      site.name.should eq("Site 1")
      site.location.not_nil!.lat.should eq(10.0)
      site.location.not_nil!.lon.should eq(90.0)

      sites[1].location.not_nil!.lat.should eq(9.91343313498688)
      sites[1].location.not_nil!.lon.should eq(90.263671875)
    end
  end
end
