class AddWeatherAmPmToFishingSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :fishing_sessions, :weather_am, :string
    add_column :fishing_sessions, :weather_pm, :string
  end
end
