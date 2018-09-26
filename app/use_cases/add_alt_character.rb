class AddAltCharacter
  include UseCase

  def initialize(user:, alt_details:)
    @user = user
    @alt_details = alt_details
  end

  def perform
    find_or_create_alt_character
  end

  private

  def find_or_create_alt_character
    if @user.character_id == @alt_details.info.character_id
      errors[:alt_character] << "cannot be the same as the main character"
    else
      @alt_character = AltCharacter.where(provider: @alt_details.provider, uid: @alt_details.uid, user: @user).first_or_create do |alt_character|
        alt_character.name = @alt_details.info.name
        alt_character.character_id = @alt_details.info.character_id
        alt_character.token = @alt_details.credentials.token
        alt_character.refresh_token = @alt_details.credentials.refresh_token
        alt_character.token_expiry = @alt_details.credentials.expires_at
        alt_character.label_id = AltCharacter::DEFAULT_LABEL["label_id"]
        alt_character.label_name = AltCharacter::DEFAULT_LABEL["label_name"]
      end
    end
  end
end
