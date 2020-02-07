RestClient::Response.class_eval do
  # Idea taken from Steve Klabnik
  # - https://words.steveklabnik.com/beware-subclassing-ruby-core-classes
  alias_method :string_initialize, :initialize

  def initialize(body, net_http_res, request, start_time)
    response_set_vars(net_http_res, request, start_time)
    string_initialize(body)
  end

  def self.create(body, net_http_res, request, start_time = nil)
    result = self.new(body || '', net_http_res, request, start_time)
    fix_encoding(result)
    result
  end
end
