require_relative 'response'

module Jpush
  module Http
    module Client
      extend self

      def get(url, params: nil, headers: {})
        send_request(:get, url, params: params, headers: headers)
      end

      def post(url, body: , headers: {})
        send_request(:post, url, body: body, headers: headers)
      end

      def delete(url, params: nil, headers: {})
        send_request(:delete, url, params: params, headers: headers)
      end

      def send_request(method, url, params: nil, body: nil, headers: {}, opts: {})
        raw_response = Utils::Http.new(
          method.to_sym,
          url,
          params: params,
          body: body,
          headers: headers,
          opts: opts
        ).basic_auth.send_request

        if raw_response.kind_of? Net::HTTPSuccess
          Response.new(raw_response.code, raw_response.body)
        else
          raise Utils::Exceptions::JpushResponseError.new(raw_response)
        end
      end

    end
  end
end
