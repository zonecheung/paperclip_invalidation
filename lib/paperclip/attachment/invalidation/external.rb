require "net/http"

module Paperclip
  class Attachment
    class Invalidation
      class External
    
        def initialize(url, settings = {})
          @url = url

          @invalidation_url = settings[:url]
          @username         = settings[:username] || ENV["CACHE_INVALIDATION_USERNAME"]
          @password         = settings[:password] || ENV["CACHE_INVALIDATION_PASSWORD"]
          @param_name       = settings[:param_name] || "filename"
        end

        def invalidate
          uri = URI.parse(@invalidation_url)
          req = Net::HTTP::Post.new(uri.path)
          req.basic_auth(@username,
                         @password) if @username.present?
          req.set_form_data(@param_name => URI.parse(@url).path)
          net = Net::HTTP.new(uri.host, uri.port)
          net.use_ssl = !! (@invalidation_url =~ /^https/)
          net.start { |http| http.request(req) }
        end

      end
    end
  end
end
