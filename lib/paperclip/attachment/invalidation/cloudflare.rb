require "net/http"

module Paperclip
  class Attachment
    class Invalidation
      class Cloudflare
    
        API_URL = "https://api.cloudflare.com/client/v4"

        def initialize(options = {})
          @host  = options[:host]
          @email = options[:email]
          @tkn   = options[:tkn]
        end

        def purge_all_files
          get_zone_ids.inject([]) { |results, id| results << purge_cache(id, purge_everything: true) }
        end

        def purge_individual_files(files = [])
          get_zone_ids.inject([]) { |results, id| results << purge_cache(id, files: files) }
        end

        private

        def get_zone_ids
          uri = URI("#{API_URL}/zones?name=#{@host}")

          Net::HTTP.start(
            uri.host, uri.port,
            use_ssl: uri.scheme == "https"
          ) do |http|
            request = Net::HTTP::Get.new uri

            request["X-Auth-Email"] = @email
            request["X-Auth-Key"] = @tkn
            request["Content-Type"] = "application/json"

            response = http.request request # Net::HTTPResponse object
            if response.is_a?(Net::HTTPSuccess)
              json = JSON.parse(response.body)
              json["result"].map { |x| x["id"] }
            else
              raise response.message.inspect
            end
          end      
        end

        def purge_cache(id, hash)
          uri = URI("#{API_URL}/zones/#{id}/purge_cache")

          Net::HTTP.start(
            uri.host, uri.port,
            use_ssl: uri.scheme == "https"
          ) do |http|
            request = Net::HTTP::Delete.new uri

            request["X-Auth-Email"] = @email
            request["X-Auth-Key"] = @tkn
            request["Content-Type"] = "application/json"

            request.body = hash.to_json

            response = http.request request # Net::HTTPResponse object
            JSON.parse(response.body)
          end      
        end

    
      end
    end
  end
end




require "net/http"

# NOTE: I'm not sure where to name this file/lib yet. :(
module Modules

  class Cloudflare


  end

end
