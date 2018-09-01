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
    response = self.class.get("/corporations/#{char_information['corporation_id']}/contacts/", query: base_params.merge(authorize_params))
    if response.success?
      response.parsed_response
    else
      []
    end
  end

  def alliance_contacts
    response = self.class.get("/alliances/#{corp_information['alliance_id']}/contacts/", query: base_params.merge(authorize_params))
    if response.success?
      response.parsed_response
    else
      []
    end
  end

  def create_contacts(standing:, contacts:)
    response = self.class.post(
      "/characters/#{@user.character_id}/contacts/",
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      },
      body: contacts.to_json,
      query: {
        standing: standing,
        watched: false
      }.merge(base_params.merge(authorize_params)))
  end

  def char_information
    return @char_information if @char_information
    response = self.class.get("/characters/#{@user.character_id}/", query: base_params)
    if response.success?
      @char_information = response.parsed_response
      unless @user.corp_id == response.parsed_response['corporation_id']
        @user.update(corp_id: response.parsed_response['corporation_id'], corp_name: corp_information['name'])
      end
    else
      @char_information = {}
    end
    @char_information
  end

  def corp_information
    return @corp_information if @corp_information
    response = self.class.get("/corporations/#{char_information['corporation_id']}/", query: base_params)
    if response.success?
      @corp_information = response.parsed_response
      unless @user.ally_id == response.parsed_response['alliance_id']
        @user.update(ally_id: response.parsed_response['alliance_id'], ally_name: ally_information['name'])
      end
    else
      @corp_information = {}
    end
    @corp_information
  end

  def ally_information
    return @ally_information if @ally_information
    response = self.class.get("/alliances/#{corp_information['alliance_id']}/", query: base_params)
    if response.success?
      @ally_information = response.parsed_response
    else
      @ally_information = {}
    end
    @ally_information
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
