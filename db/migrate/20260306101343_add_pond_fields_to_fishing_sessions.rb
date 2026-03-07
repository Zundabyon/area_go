class AddPondFieldsToFishingSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :fishing_sessions, :water_condition, :string
    add_column :fishing_sessions, :pond_number, :string
  end
end
