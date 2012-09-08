require "net/http"

module Paperclip
  class Attachment
    class Invalidation
      class Cloudflare
    
        def initialize(url, settings = {})
          @url = url
          
          @file_purge_url = settings[:url] || ENV["CLOUDFLARE_FILE_PURGE_URL"] || "https://www.cloudflare.com/api_json.html"
          @tkn            = settings[:tkn] || ENV["CLOUDFLARE_TKN"]
          @email          = settings[:email] || ENV["CLOUDFLARE_EMAIL"]
          @host           = settings[:host] || ENV["HOST"].to_s.sub(/^www\./, "")
        end


        def invalidate
          uri = URI.parse(@file_purge_url)
          req = Net::HTTP::Post.new(uri.path)
          req.set_form_data("a"     => "zone_file_purge",
                            "z"     => @host,
                            "tkn"   => @tkn,
                            "email" => @email,
                            "url"   => @url)
          net = Net::HTTP.new(uri.host, uri.port)
          net.use_ssl = !! (@file_purge_url =~ /^https/)
          net.start { |http| http.request(req) }
        end
    
      end
    end
  end
end




