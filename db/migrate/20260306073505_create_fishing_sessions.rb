class CreateFishingSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :fishing_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true
      t.date :fished_on
      t.string :weather
      t.text :memo

      t.timestamps
    end
  end
end
