require "http/client"

module EventQL
  class Client
    @opts : OptionType

    def initialize(@opts = OptionType.new)
    end

    # v1 doc
    # https://eventql.io/documentation/api/http/sql
    def query(query_str : String, opts = OptionType.new)
      Query.new(self, query_str, opts)
    end

    # v1 doc
    # https://eventql.io/documentation/api/http/tables/insert
    def insert!(body : String)
      headers = HTTP::Headers.new
      headers.add "Content-Type", "application/json"

      if has_auth_token?
        headers.add "Authorization", "Token #{get_auth_token}"
      end

      http = HTTP::Client.new(get_host, get_port)

      response = http.post("/api/v1/tables/insert", headers, body)

      if response.status_code == 201
        return true
      else
        raise Error.new(message: "EventQL: insert error - #{response.body[0..128]}")
      end
    end

    def get_host
      @opts["host"]
    end

    def get_port
      @opts["port"]
    end

    def get_database
      @opts["database"]
    end

    def get_auth_token
      @opts["auth_token"]?
    end

    def has_auth_token?
      !@opts["auth_token"]?.nil?
    end
  end
end
