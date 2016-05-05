module JPush
  module Http
    class Response

      attr_accessor :http_code, :body, :heades

      def initialize(raw_response)
        @http_code = raw_response.code.to_i
        @body = parse_body(raw_response.body)

        Utils::Log.log_response(@http_code, @body)

        unless raw_response.kind_of? Net::HTTPSuccess
          begin
            build_error
          rescue Utils::Exceptions::AppKeyError => e
            Utils::Log.log_error "AppKeyError: #{e}"
          end
        end
      end

      private

        def parse_body(body)
          body = JSON.parse(body)
        rescue JSON::ParserError
          body
        end

        def build_error
          error_code, error_message =
            if @body.has_key?('error')
              [@body['error']['code'], @body['error']['message']]
            else
              [@body['code'], @body['message']]
            end

          case error_code
          when 2003
            raise Utils::Exceptions::AppKeyError.new(http_code, error_code, error_message)
          else
            raise Utils::Exceptions::JPushResponseError.new(http_code, error_code, error_message)
          end
        end

    end
  end
end
