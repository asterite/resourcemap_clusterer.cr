class Object
  macro json_schema(properties)
    {% for key, value in properties %}
      property :{{key.id}}
    {% end %}

    def self.new(_pull : Json::PullParser)
      {% for key, value in properties %}
        {{key.id}} = nil
      {% end %}

      _pull.read_object do |_key|
        case _key
        {% for key, value in properties %}
          when {{value[:key] || key.id.stringify}}
            {% if value[:nilable] == true %}
              {{key.id}} = _pull.read_null_or { {{value[:type]}}.new(_pull) }
            {% else %}
              {{key.id}} = {{value[:type]}}.new(_pull)
            {% end %}
        {% end %}
        else
          _pull.skip
        end
      end

      {% for key, value in properties %}
        {% unless value[:nilable] %}
          unless {{key.id}}
            raise "missing json attribute: {{(value[:key] || key).id}}"
          end
        {% end %}
      {% end %}

      new(
        {% for key, value in properties %}
          {{key.id}},
        {% end %}
      )
    end

    def initialize(
      {% for key, value in properties %}
        @{{key.id}},
      {% end %}
      )
    end

    def to_json(io : IO)
      io.json_object do |json|
        {% for key, value in properties %}
          json.field({{value[:key] || key.id.stringify}}) do
            @{{key.id}}.to_json(io)
          end
        {% end %}
      end
    end
  end
end
