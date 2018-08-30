class EveSwaggerInterfaceService
  include HTTParty
  base_uri 'https://esi.evetech.net/latest'
  debug_output $stdout

  def initialize(user)
    @user = user
  end

  def character_contacts
    response = self.class.get("/characters/#{@user.character_id}/contacts/", query: base_params.merge(authorize_params))
    if response.success?
      response.parsed_response
    else
      []
    end
  end

  def corporation_contacts
    response = self.class.get("/corporations/#{public_information['corporation_id']}/contacts/", query: base_params.merge(authorize_params))
    if response.success?
      response.parsed_response
    else
      []
    end
  end

  def alliance_contacts
    response = self.class.get("/alliances/#{public_information['alliance_id']}/contacts/", query: base_params.merge(authorize_params))
    if response.success?
      response.parsed_response
    else
      []
    end
  end

  def public_information
    return @public_information if @public_information
    response = self.class.get("/characters/#{@user.character_id}/", query: base_params)
    if response.success?
      @public_information = response.parsed_response
    else
      @public_information = {}
    end
  end

  private

  def base_params
    {
      datasource: "tranquility"
    }
  end

  def authorize_params
    {
      token: @user.current_token
    }
  end

end
