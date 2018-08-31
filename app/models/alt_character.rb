class AltCharacter < ApplicationRecord
  belongs_to :user

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
