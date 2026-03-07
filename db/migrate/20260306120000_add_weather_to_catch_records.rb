class AddWeatherToCatchRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :catch_records, :weather,       :string
    add_column :catch_records, :wind_strength, :string
  end
end
