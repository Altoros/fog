require 'multi_json'

module Fog
  module JSON

    def self.sanitize(data)
      case data
      when Array
        data.map {|datum| sanitize(datum)}
      when Hash
        for key, value in data
          data[key] = sanitize(value)
        end
      when ::Time
        data.strftime("%Y-%m-%dT%H:%M:%SZ")
      else
        data
      end
    end

    # Do the MultiJson introspection at this level so we can define our encode/decode methods and perform
    # the introspection only once rather than once per call.

    if MultiJson.respond_to?(:dump)
      def self.encode(obj)
        MultiJson.encode(obj)
      end
    else
      def self.encode(obj)
        MultiJson.encode(obj)
      end
    end

    if MultiJson.respond_to?(:load)
      def self.decode(obj)
        MultiJson.decode(obj)
      end
    else
      def self.decode(obj)
        MultiJson.decode(obj)
      end
    end


  end
end