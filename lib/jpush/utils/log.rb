require 'logger'

module JPush
  module Utils
    module Log
      extend self

      def logger
        if @logger.nil?
          @logger = Logger.new($stdout)
          @logger.progname = 'JPush'
          @logger.level = Logger::INFO
          @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
        end
        @logger
      end

      def log_level=(level)
        logger.level = level
      end

      def log_request(url, method, params, body)
        msg = "HTTP #{method.to_s.upcase} request to #{url} "
        msg += " query: {#{params}}" if params
        msg += " body: {#{body}}" if body
        logger.debug(msg)
      end

      def log_response(http_code, body)
        msg = "HTTP RESPONSE: "
        msg += " http status code: [#{http_code}]"
        msg += " body: {#{@body}}" unless @body.nil? || @body.empty?
        logger.debug(msg + "\n")
      end

      def log_error(msg)
        logger.error(msg)
      end

    end
  end
end
