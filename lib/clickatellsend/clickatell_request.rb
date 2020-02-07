module Clickatellsend

	class Request

    # :url, :user, :password, :app_id (optional)
		def initialize(opts = {})
			config = Clickatellsend.config
			config = config.merge(opts)

			@url = config[:url]
			@user = config[:user]
			@password = config[:password]
			@api_id = config[:api_id]
	  end

	  # :to, :text, :deliv_time
	  def send_msg(params)
			response(Faraday.new(@url).get("http/sendmsg", options(params)))
	  end

	  def get_balance
	  	response(Faraday.new(@url).get("http/getbalance", options({})))
	  end

	  # :apimsgid
	  def get_msg_charge(params)
	  	response(Faraday.new(@url).get("http/getmsgcharge", options(params)))
	  end

	  # :msisdn
	  def route_coverage(params)
	  	response(Faraday.new(@url).get("utils/routecoverage", options(params)))
	  end

	  # :apimsgid
	  def get_msg_status(params)
	  	response(Faraday.new(@url).get("http/querymsg", options(params)))
	  end

	  # :apimsgid
	  def stop_msg(params)
	  	response(Faraday.new(@url).get("http/delmsg", options(params)))
	  end

	  def auth
	  	response(Faraday.new(@url).get("http/auth", options({})))
	  end

	  # :session_id
	  def prevent_expiring(params)
			response(Faraday.new(@url).get("http/ping", options(params)))
	  end

	  private

	  	def options(params)
	  		if params[:session_id]
	  			params.merge({:api_id => @api_id})
	  		else
	  			params.merge({:user => @user, :password => @password, :api_id => @api_id})
	  		end
	  	end

	  	def response(request)
	  		if request.status == 200
	  			response = request.body.split("\n").map{|l| l.scan /(\w+):\s($|[\w, \d.]+)(?:\s|$)/}.map &:to_h
	  			if response.size == 1
	  				response[0]
	  			end
		  	else
		  		{:ERR => "Could not connect to the API, double check your settings and internet connection"}
		  	end
	  	end

	end

end
