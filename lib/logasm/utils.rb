require 'socket'

class Logasm
  module Utils
    HOST = ::Socket.gethostname

    # Build logstash json compatible event
    #
    # @param [Hash] metadata
    # @param [#to_s] level
    # @param [String] service_name
    #
    # @return [Hash]
    def self.build_event(metadata, level, service_name)
      metadata.merge(
        application: application_name(service_name),
        level: level.to_s.downcase,
        host: HOST,
        :@timestamp => Time.now.utc.iso8601(3)
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
  end
end