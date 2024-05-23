class AlteryxClient::Configuration
  EXPIRY = 1800

  attr_accessor :username,
                :password,
                :session_url,
                :api_url,
                :expiry,
                :designer_expert_uuid,
                :predictive_master_uuid

  def initialize(opts = {})
    @expiry = EXPIRY
    @username = opts["username"]
    @password = opts["password"]
    @session_url = opts["session_url"]
    @api_url = opts["api_url"]
    @designer_expert_uuid = opts["designer_expert_uuid"]
    @predictive_master_uuid = opts["predictive_master_uuid"]
  end
end
