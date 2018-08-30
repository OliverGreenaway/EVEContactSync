class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[crest]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.character_id = auth.info.character_id
      user.token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.token_expiry = auth.credentials.expires_at
    end
  end
end
