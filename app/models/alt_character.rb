class AltCharacter < ApplicationRecord
  belongs_to :user

  DEFAULT_LABEL = {"label_id" => 0, "label_name" => 'None'}

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
    return "Never" if last_sync.nil?
    seconds_diff = (Time.now - last_sync).to_i.abs

    days = seconds_diff / 86400
    seconds_diff -= days * 86400

    hrs = seconds_diff / 3600
    seconds_diff -= hrs * 3600

    mins = seconds_diff / 60
    seconds_diff -= mins * 60

    secs = seconds_diff

    return "#{days} days " if days > 0
    return "#{hrs} hrs " if days > 0 || hrs > 0
    return "#{mins} mins " if days > 0 || hrs > 0 || mins > 0
    return "#{secs} secs"
  end

  def labels
    return DEFAULT_LABEL unless user.premium?
    esi_client = EveSwaggerInterfaceService.new(self)
    labels = esi_client.contact_labels.sort_by {|l| l["label_name"]}
    [DEFAULT_LABEL] + labels
  end
end
