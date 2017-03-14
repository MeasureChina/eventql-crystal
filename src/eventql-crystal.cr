require "./eventql/**"

module EventQL
  alias OptionValueType = String
  alias OptionType = Hash(String, OptionValueType)
  
  class Error < Exception; end
  class QueryError < Error; end
  
  def self.connect(opts)
    Client.new(opts)
  end
end
