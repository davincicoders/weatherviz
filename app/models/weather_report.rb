class WeatherReport < ActiveRecord::Base
  belongs_to :location, touch: true, autosave: true

  def self.search(search)
    if search
      WeatherReport.joins(:location).where("city LIKE ?", "%#{search}%")
    else
      WeatherReport.all
    end
  end

  def location
    Location.find(self.location_id).city
  end
end
