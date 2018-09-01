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

  def time_since_last_sync
    seconds_diff = (Time.now - last_sync).to_i.abs

    days = seconds_diff / 86400
    seconds_diff -= days * 86400

    hrs = seconds_diff / 3600
    seconds_diff -= hrs * 3600

    mins = seconds_diff / 60
    seconds_diff -= mins * 60

    secs = seconds_diff

    output = ''
    output += "#{days} days " if days > 0
    output += "#{hrs} hrs " if days > 0 || hrs > 0
    output += "#{mins} mins " if days > 0 || hrs > 0 || mins > 0
    output += "#{secs} secs" if days > 0 || hrs > 0 || mins > 0 || secs > 0
    output = "Never" if output == ''
    output

  end
end
