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

  def current_token
    refresh_token!
    token
  end

  def refresh_token!
    if self.refresh_token
      if Time.at(self.token_expiry) <= Time.now
        response = HTTParty.post(
          "https://login.eveonline.com/oauth/token",
          headers: {
            Authorization: "Basic #{Base64.encode64("#{ENV['ESI_CLIENT_ID']}:#{ENV['ESI_SECRET_KEY']}").tr("\n",'')}",
          },
          body: {
            grant_type: 'refresh_token',
            refresh_token: self.refresh_token
          }
        )
        if response.success?
          self.token = response.parsed_response['access_token']
          self.token_expiry = Time.now.to_i + response.parsed_response['expires_in']
          self.refresh_token = response.parsed_response['refresh_token']
          self.save!
        end

      end
    end
  end
end
