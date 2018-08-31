class AddAltCharacter
  include UseCase

  def initialize(user:, alt_details:)
    @user = user
    @alt_details = alt_details
  end

  def perform
    find_or_create_alt_character
    add_to_user
  end

  private

  def find_or_create_alt_character
    @alt_character = AltCharacter.where(provider: @alt_details.provider, uid: @alt_details.uid).first_or_create do |alt_character|
      alt_character.name = @alt_details.info.name
      alt_character.character_id = @alt_details.info.character_id
      alt_character.token = @alt_details.credentials.token
      alt_character.refresh_token = @alt_details.credentials.refresh_token
      alt_character.token_expiry = @alt_details.credentials.expires_at
    end
    byebug
  end

  def add_to_user
    byebug
    unless @user.alt_characters.include? @alt_character
      @user.alt_characters << @alt_character
      @user.save
    end
  end
end
