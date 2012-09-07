require "net/http"

module Paperclip
  class Attachment

    class Invalidation

      def initialize(url, settings = {})
        @url = url

        @cache_invalidation_url        = settings[:cache_invalidation_url]
        @cache_invalidation_username   = settings[:cache_invalidation_username] || ENV["CACHE_INVALIDATION_USERNAME"]
        @cache_invalidation_password   = settings[:cache_invalidation_password] || ENV["CACHE_INVALIDATION_PASSWORD"]
        @cache_invalidation_param_name = settings[:cache_invalidation_param_name] || "filename"
        
        @cloudflare_file_purge_url     = settings[:cloudflare_file_purge_url] || ENV["CLOUDFLARE_FILE_PURGE_URL"] || "https://www.cloudflare.com/api_json.html"
        @cloudflare_tkn                = settings[:cloudflare_tkn] || ENV["CLOUDFLARE_TKN"]
        @cloudflare_email              = settings[:cloudflare_email] || ENV["CLOUDFLARE_EMAIL"]
        @host                          = settings[:host] || ENV["HOST"].to_s.sub(/^www\./, "")
      end

      def invalidate_on_asset_host
        uri = URI.parse(@cache_invalidation_url)
        req = Net::HTTP::Post.new(uri.path)
        req.basic_auth(@cache_invalidation_username,
                       @cache_invalidation_password) if @cache_invalidation_username.present?
        req.set_form_data(@cache_invalidation_param_name => URI.parse(@url).path)
        net = Net::HTTP.new(uri.host, uri.port)
        net.use_ssl = !! (@cache_invalidation_url =~ /^https/)
        net.start { |http| http.request(req) }
      end

      def invalidate_on_cloudflare
        uri = URI.parse(@cloudflare_file_purge_url)
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data("a"     => "zone_file_purge",
                          "z"     => @host,
                          "tkn"   => @cloudflare_tkn,
                          "email" => @cloudflare_email,
                          "url"   => @url)
        net = Net::HTTP.new(uri.host, uri.port)
        net.use_ssl = !! (@cloudflare_file_purge_url =~ /^https/)
        net.start { |http| http.request(req) }
      end

    end

  end
end

