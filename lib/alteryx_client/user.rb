class AlteryxClient::User
  attr_accessor :email,
                :uuid,
                :login,
                :first_name,
                :last_name,
                :id,
                :deleted,
                :eligibility_designer_expert,
                :eligibility_predictive_master

  def self.from_alteryx_api(json)
    return nil if json["error"].present?
    AlteryxClient::User.new(id: json["id"],
      login: json["login"],
      email: json["email"],
      uuid: json["uuid"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      deleted: json["deleted"],
      eligibility_designer_expert: json["eligiblity-designer-expert"],
      eligibility_predictive_master: json["eligiblity-predictive-master"]
    )
  end

  def initialize(opts = {})
    opts.symbolize_keys!

    @id = opts[:id]
    @uuid = opts[:uuid]
    @login = opts[:login]
    @first_name = opts[:first_name]
    @last_name = opts[:last_name]
    @email = opts[:email]
    @deleted = opts[:deleted].to_s.downcase == "true"
    @eligibility_designer_expert = opts[:eligibility_designer_expert].to_s.downcase == "true"
    @eligibility_predictive_master = opts[:eligibility_predictive_master].to_s.downcase == "true"

    self
  end

  def to_s
    "#{email}>"
  end

  def deleted?
    !!deleted
  end

  def eligibility_designer_expert?
    !!eligibility_designer_expert
  end

  def eligibility_predictive_master?
    !!eligibility_predictive_master
  end

  def eligible?(exam_uuid)
    return false if deleted?

    case exam_uuid
    when AlteryxClient.configuration.designer_expert_uuid
      eligibility_designer_expert?
    when AlteryxClient.configuration.predictive_master_uuid
      eligibility_predictive_master?
    else
      false
    end
  end
end
