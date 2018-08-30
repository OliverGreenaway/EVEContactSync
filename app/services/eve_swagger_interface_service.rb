class EveSwaggerInterfaceService
  include HTTParty
  base_uri 'https://esi.evetech.net'

  def initialize(user)
    @user = user
  end

  def character_contacts
    response = self.class.get("/latest/characters/#{@user.character_id}/contacts/", query: base_params)
    if response.success?
      response.parsed_response
    else
      []
    end
  end

  def corporation_contacts

  end

  def alliance_contacts

  end

  private

  def base_params
    {
      datasource: "tranquility",
      token: @user.token
    }
  end

end
