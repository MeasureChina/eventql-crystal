require "http/client"

module EventQL
  class Query
    @client : Client
    @query_str : String
    @query_opts : OptionType
    
    def initialize(@client, @query_str, @query_opts = OptionType.new)
    end

    def execute!
      headers = HTTP::Headers.new
      headers.add "Content-Type", "application/json"

      if has_auth_token?
        headers.add "Authorization", "Token #{get_auth_token}"
      end

      http = HTTP::Client.new(@client.get_host, @client.get_port)

      body = {
        query: @query_str,
        database: @client.get_database,
        format: "json"
      }.to_json

      response = HTTP::Client.post("/api/v1/sql", headers, body)

      response_json = JSON.parse(response.body) rescue nil
      if response_json && response_json["error"]?
        raise QueryError.new(message: response_json["error"])
      end

      if response_json.nil? || response.status_code != 200
        raise Error.new(message: "HTTP ERROR (#{response.code}): #{response.body[0..128]}")
      end

      response_json["results"]
    end
  end
end
