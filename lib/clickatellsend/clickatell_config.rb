module Clickatellsend
  def self.config(&block)
    @configuration ||= Configuration.new
    unless block.nil?
      yield @configuration
    else
      @configuration.config
    end
  end

  class Configuration
    attr_accessor :url, :user, :password, :api_id

    def initialize
      @url = nil
      @user = nil
      @password = nil
      @api_id = nil
    end

    def config
      { :url      => @url,
        :user     => @user,
        :password => @password,
        :api_id   => @api_id }
    end
  end
end
