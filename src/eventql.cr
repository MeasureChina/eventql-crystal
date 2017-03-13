require "./eventql/**"

module EventQL
  alias OptionValueType = String | Int32 | Nil
  alias OptionType = Hash(String, OptionValueType)
  
  class Error < Exception; end
  class QueryError < Error; end
  
  def self.connect(opts)
    Client.new(opts)
  end
end
