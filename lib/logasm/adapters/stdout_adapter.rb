class Logasm
  module Adapters
    class StdoutAdapter
      attr_reader :logger

      def initialize(level, *)
        @logger = Logger.new(STDOUT)
        @logger.level = level
      end

      def log(level, metadata = {})
        message = metadata[:message]
        data = metadata.select { |key, value| key != :message }
        log_data = [message, data.empty? ? nil : data.to_json].compact.join(' ')

        @logger.public_send level, log_data
      end
    end
  end
end