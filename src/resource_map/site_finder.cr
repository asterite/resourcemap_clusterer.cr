require "json"

class ResourceMap::SiteFinder
  def initialize(@listener)
  end

  def parse(json)
    pull = Json::PullParser.new(json)
    pull.on_key("hits") do
      pull.on_key("hits") do
        pull.read_array do
          site = nil
          collection_id = nil

          pull.read_object do |key|
            case key
            when "_index"
              index = pull.read_string
              if index =~ /(\d+)/
                collection_id = $1.to_i
              end
            when "_source"
              site = Site.new(pull)
            else
              pull.skip
            end
          end

          if site
            site.collection_id = collection_id
            @listener.add site
          end
        end
      end
    end
  end
end
