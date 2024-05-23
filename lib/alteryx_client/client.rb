class AlteryxClient::Client
  attr_accessor :config, :token

  def initialize(config = AlteryxClient.configuration)
    @config = config
    logger("Configured: #{config.to_json(except: ["username", "password"])}")
  end

  def configure
    yield config
  end

  def get_user_by_id(id)
    logger "Getting user by ID #{id}"
    begin
      retries ||= 0
      get_token if token.blank?
      uri = URI.parse(URI.encode(config.api_url.strip + "/ta_useremail_validate"))

      response = RestClient.get(uri.to_s, { "Li-Api-Session-Key" => token,
                                         content_type: "application/json",
                                         params: { id: id } })
      logger "RAW response: #{response}"
      json = JSON.parse(response)
      if json["status"] == "success"
        # user = AlteryxClient::Client.new.get_user("1@2.com")
        return AlteryxClient::User.from_alteryx_api(json["users"][0])
      else
        #response code is always 200, need to analyze message
        raise RestClient::Unauthorized if json["message"] == "User is not authenticated"
        raise AlteryxClient::Error.new("Error getting user by ID: #{json["message"]}")
      end

    rescue RestClient::Unauthorized => e
      get_token
      retry if (retries += 1) < 2
    rescue RestClient::Exception => e
      logger("Exception #{e} -- #{e.response}")
      raise AlteryxClient::Error.new("Error connecting to Alteryx: #{e.response.code}")
    end
  end

  def get_user(email)
    logger "Getting user by #{email}"
    begin
      retries ||= 0
      get_token if token.blank?
      uri = URI.parse(URI.encode(config.api_url.strip + "/ta_useremail_validate"))

      response = RestClient.get(uri.to_s, { "Li-Api-Session-Key" => token,
                                         content_type: "application/json",
                                         params: { email_id: email } })
      logger "RAW response: #{response}"
      json = JSON.parse(response)
      if json["status"] == "success"
        # user = AlteryxClient::Client.new.get_user("1@2.com")
        return AlteryxClient::User.from_alteryx_api(json["users"][0])
      else
        #response code is always 200, need to analyze message
        raise RestClient::Unauthorized if json["message"] == "User is not authenticated"
        raise AlteryxClient::Error.new("Error getting user email: #{json["message"]}")
      end

    rescue RestClient::Unauthorized => e
      get_token
      retry if (retries += 1) < 2
    rescue RestClient::Exception => e
      logger("Exception #{e} -- #{e.response}")
      raise AlteryxClient::Error.new("Error connecting to Alteryx: #{e.response.code}")
    end
  end

  def get_token
    logger "Getting token"
    raise ArgumentError.new("Please provide session_url") unless config.session_url
    raise ArgumentError.new("Please provide username") unless config.username
    raise ArgumentError.new("Please provide password") unless config.password

    begin
      uri = URI.parse(URI.encode(config.session_url.strip))
      uri.query = URI.encode_www_form({ "user.login" => config.username, "user.password" => config.password })


      response = RestClient::Request.execute(method: "POST", payload: "", url: uri.to_s)

      response_hash = Hash.from_xml(response.body)["response"]

      if response_hash["status"] == "success"
        @token = response_hash["value"]
      else
        raise AlteryxClient::Error.new("Response status for token is not \"success\"")
      end

      @token
    rescue RestClient::Exception => e
      logger("Exception #{e} -- #{e.response}")
      raise AlteryxClient::Error.new("Error getting token from Alteryx: #{e.response.code}")
    end
  end

  private
  def logger(message)
    message = "Alteryx CLIENT: #{message}"
    unless @logger
      begin
        @logger = ::Rails.logger
        RestClient.log = @logger
      rescue NoMethodError, NameError
        @logger = Logger.new(STDERR)
        RestClient.log = @logger
        @logger.warn "No rails logger, using standalone"
      end
    end

    @logger.warn("Alteryx: #{message}")
  end

end
