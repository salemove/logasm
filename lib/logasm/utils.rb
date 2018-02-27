require 'time'

class Logasm
  module Utils
    DECIMAL_FRACTION_OF_SECOND = 3

    # Build logstash json compatible event
    #
    # @param [Hash] metadata
    # @param [#to_s] level
    # @param [String] service_name
    #
    # @return [Hash]
    def self.build_event(metadata, level, service_name)
      overwritable_params
        .merge(serialize_time_objects(metadata))
        .merge(
          application: application_name(service_name),
          level: level.to_s.downcase
        )
    end

    # Return application name
    #
    # Returns lower snake case application name. This allows the
    # application value to be used in the elasticsearch index name.
    #
    # @param [String] service_name
    #
    # @return [String]
    def self.application_name(service_name)
      Inflecto.underscore(service_name)
    end

    def self.overwritable_params
      {
        :@timestamp => Time.now.utc.iso8601(DECIMAL_FRACTION_OF_SECOND)
      }
    end

    def self.serialize_time_objects(object)
      if object.is_a?(Hash)
        object.reduce({}) do |hash, (key, value)|
          hash.merge(key => serialize_time_objects(value))
        end
      elsif object.is_a?(Array)
        object.map(&method(:serialize_time_objects))
      elsif object.is_a?(Time) || object.is_a?(Date)
        object.iso8601
      else
        object
      end
    end

    private_class_method :overwritable_params
  end
end
