class Tag < ActiveRecord::Base
  attr_accessible :epc, :shortcode_sensor, :timestamp

  before_validation :set_area

  AREAS = %w[quarto sala cozinha]


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
