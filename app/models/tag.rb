class Tag < ActiveRecord::Base
  attr_accessible :epc, :shortcode_sensor, :timestamp

  before_validation :set_area, :set_timestamp_format
  after_save :notify_clients

  AREAS = %w[quarto sala cozinha]



  def set_timestamp_format
    if self.timestamp_before_type_cast.kind_of? String
      timestamp = self.timestamp_before_type_cast[0..9]
      puts "timestamp: (#{timestamp})"
      self.timestamp = DateTime.strptime(timestamp,'%s')
    end
  end

  def notify_clients
    clients = Client.where(:area => self.area)
    clients.each do |client|
      options = { :query => {area: self.area, epc: self.epc, timestamp: self.timestamp}}
      response = HTTParty.post(client.url, options)
      puts "Notificacao enviada!!!!"
    end
  end

  private
  def set_area
    tags_file = Rails.root.join("config/tags.yml")
    tags = YAML.load_file(tags_file)
    Tag::AREAS.each do |area|
      if tags[area].has_value?(self.shortcode_sensor.to_i)
        self.area = area
      end
    end
  end
end
